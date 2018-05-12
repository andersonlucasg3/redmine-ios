//
//  RefreshableTableViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import PKHUD
import GenericDataSourceSwift

protocol RefreshableTableViewProtocol: class {
    func reloadTableView()
}

class RefreshableTableViewController<RequestResult: BasicResult&SpecificResultProtocol, ItemType: Basic, SectionType: Section>
    : UITableViewController, LoadMoreViewControllerProtocol, GenericDelegateDataSourceProtocol, RequestProtocol, RefreshableTableViewProtocol {
    fileprivate weak var noContentViewController: NoContentViewController?
    
    let sessionController = SessionController()
    
    var request: Request?
    var requestResult: RequestResult!
    
    var pageCounter: PageCounterController?
    
    weak var dataSource: DataSource<ItemType>!
    var delegateDataSource: GenericDelegateDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupRefreshControl()
        self.setupDataSourceIfPossible()
    }
    
    fileprivate func setupTableView() {
        self.tableView.contentInset.bottom = 20
    }
    
    func clearCurrentContent() {
        self.pageCounter = nil
        self.requestResult = nil
    }
    
    // MARK: DataSource functions
    
    func postSetupDataSource() {} // empty for overriding only
    
    func createDataSource(with items: [ItemType]) -> DataSource<ItemType> {
        let dt = DataSource<ItemType>.init()
        dt.items = items
        return dt
    }
    
    func performDataSourceOperations(_ dataSource: DataSource<ItemType>) {} // empty for overriding only
    
    fileprivate func finishDataSourceSetup(_ dataSource: DataSource<ItemType>, _ sections: [Section]) {
        self.dataSource = dataSource
        self.delegateDataSource = GenericDelegateDataSource(withSections: sections, andTableView: self.tableView)
        
        self.tableView.delegate = self.delegateDataSource
        self.tableView.dataSource = self.delegateDataSource
        self.delegateDataSource.delegate = self
    }
    
    func loadMoreItemsName() -> String {
        return "Things"
    }
    
    func setupDataSource(with items: [ItemType]) {
        let dataSource = self.createDataSource(with: items)
        self.performDataSourceOperations(dataSource)
        
        var sections: [Section] = [SectionType.init(dataSource: dataSource)]
        if self.pageCounter?.hasNextPage ?? false {
            let dts = DataSource<String>.init()
            dts.items = [self.loadMoreItemsName()]
            sections.append(LoadMoreSection.init(dataSource: dts))
        }
        
        self.finishDataSourceSetup(dataSource, sections)
    }
    
    func setupDataSourceIfPossible(with items: [ItemType]) {
        if let _ = self.tableView, items.count > 0 {
            self.setupDataSource(with: items)
        } else {
            self.showNoContentBackgroundView()
        }
    }
    
    func setupDataSourceIfPossible() {
        if let requestResult = self.requestResult {
            self.setupDataSourceIfPossible(with: requestResult.results as? [ItemType] ?? [])
            self.postSetupDataSource()
        } else {
            self.startRefreshing()
        }
    }
    
    // MARK: Refresh Control functions
    
    fileprivate func setupRefreshControl() {
        if let refreshControl = self.refreshControl {
            refreshControl.addTarget(self, action: #selector(self.refreshControl(sender:)), for: .valueChanged)
            refreshControl.tintColor = Colors.applicationMainColor
            if #available(iOS 10.0, *) {
                self.tableView.refreshControl = refreshControl
            } else {
                self.tableView.addSubview(refreshControl)
            }
        }
    }
    
    // MARK: No Content Background View
    
    func showNoContentBackgroundView() {
        let noContentViewController = NoContentViewController.instantiate()!
        self.addChildViewController(noContentViewController)
        self.view.addSubview(noContentViewController.view)
        self.view.sendSubview(toBack: noContentViewController.view)
        self.noContentViewController = noContentViewController
    }
    
    func removeNoContentBackgroundView() {
        if let noContentViewController = self.noContentViewController {
            noContentViewController.removeFromParentViewController()
            noContentViewController.view.removeFromSuperview()
        }
        self.noContentViewController = nil
    }
    
    func reloadTableView() {
        guard let tableView = self.tableView else { return }
        if tableView.numberOfSections > 0 {
            self.tableView?.reloadData()
        } else {
            self.showNoContentBackgroundView()
        }
    }
    
    // MARK: Requests
    
    func requestEndPoint() -> String {
        return "" // to be overriden in each class
    }
    
    func createRequest(with endPoint: String) -> Request {
        let request = Request(url: endPoint, method: .get)
        request.delegate = self
        return request
    }
    
    fileprivate func setupRequestHeaders(_ request: Request) {
        request.addHeader(for: "X-Redmine-API-Key", with: self.sessionController.user?.apiKey ?? "")
    }
    
    // MARK: Refreshing
    
    func startRefreshing() {
        self.removeNoContentBackgroundView()
        HUD.show(.progress)
        
        let request = self.createRequest(with: self.requestEndPoint())
        self.setupRequestHeaders(request)
        request.start()
        self.request = request
    }
    
    func endRefreshing(with success: Bool) {
        HUD.flash(success ? .success : .error)
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: UIRefreshControl
    
    @objc fileprivate func refreshControl(sender: UIRefreshControl) {
        self.clearCurrentContent()
        self.startRefreshing()
    }
    
    // MARK: GenericDelegateDataSourceProtocol
    
    func didSelectItem(at indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            self.loadNextPage()
        }
    }
    
    func createRequestResult(from content: String?, of request: Request) -> RequestResult? {
        guard let requestResult: RequestResult = ApiResultProcessor.processResult(content: content) else {
            self.request(request, didFailWithError: RequestError.statusCode(code: 404, content: content))
            return nil
        }
        return requestResult
    }
    
    // MARK: RequestProtocol
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        guard let requestResult = self.createRequestResult(from: content, of: request) else {
            return
        }
        
        if self.requestResult == nil {
            self.requestResult = requestResult
        } else {
            self.requestResult.append(from: requestResult as RequestResult)
        }
        
        self.setupPageCounterIfNeeded(totalItems: self.requestResult.totalCount)
        self.setupDataSourceIfPossible()
        self.reloadTableView()
        
        self.endRefreshing(with: true)
    }
    
    func request(_ request: Request, didFailWithError error: Error) {
        print(#function)
        print(error)
        
        self.endRefreshing(with: false)
    }
}