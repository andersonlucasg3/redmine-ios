//
//  SearchableTableViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

class SearchableTableViewController<RequestResult: BasicResult&SpecificResultProtocol, ItemType: Basic, SectionType: Section>
        : RefreshableTableViewController<RequestResult, ItemType, SectionType>, UISearchResultsUpdating, UISearchBarDelegate {
    weak var searchController: UISearchController?
    
    fileprivate var overridingWithSearchRequest = false
    
    var searchType: SearchType! { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchController()
        self.setupDataSourceIfPossible()
    }
    
    override func performDataSourceOperations(_ dataSource: DataSource<ItemType>) {
        super.performDataSourceOperations(dataSource)
        if let dt = self.getSearchableDataSource() {
            self.performSearch(in: dt)
        }
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Projects"
        searchController.searchBar.delegate = self
        if #available(iOS 9.1, *) {
            searchController.dimsBackgroundDuringPresentation = false
            searchController.obscuresBackgroundDuringPresentation = false
        }
        self.definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        } else {
            self.tableView.tableHeaderView = searchController.searchBar
        }
        self.searchController = searchController
    }
    
    override func createDataSource(with items: [ItemType]) -> DataSource<ItemType> {
        return SearchableDataSource<ItemType>.init(items)
    }
    
    func performSearch(in dataSource: SearchableDataSource<ItemType>) {
        if let searchController = self.searchController {
            dataSource.performSearch(searchController.searchBar.text)
        }
    }
    
    func updateSearch(for controller: UISearchController) {
        self.getSearchableDataSource()?.performSearch(self.searchController?.searchBar.text)
        self.reloadTableView()
    }
    
    func createResult(content: String?) -> SearchResult? {
        return ApiResultProcessor.processResult(content: content)
    }
    
    override func createRequestResult(from content: String?, of request: Request) -> RequestResult? {
        if self.overridingWithSearchRequest {
            guard let searchResult: SearchResult = self.createResult(content: content) else {
                self.request(request, didFailWithError: .statusCode(code: 404, content: content))
                return nil
            }
            guard let requestResult: RequestResult = searchResult.transform() else {
                NSException.init(name: .init(rawValue: "SearchResult not found..."), reason: "SearchResult could not be created...").raise()
                return nil
            }
            return requestResult
        }
        return super.createRequestResult(from: content, of: request)
    }
    
    // Overriding createRequest
    
    override func createRequest(with endPoint: String) -> Request {
        if let searchType = self.searchType {
            let query = self.searchController?.searchBar.text ?? ""
            let overridingEndPoint = Ambients.getSearchPath(with: self.sessionController, query: query, page: self.pageCounter?.currentPage ?? 0, searchType: searchType)
            return super.createRequest(with: self.overridingWithSearchRequest ? overridingEndPoint : endPoint)
        }
        return super.createRequest(with: endPoint)
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        self.updateSearch(for: searchController)
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.overridingWithSearchRequest = true
        self.clearCurrentContent()
        self.startRefreshing()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if self.overridingWithSearchRequest {
            self.overridingWithSearchRequest = false
            self.clearCurrentContent()
            self.startRefreshing()
        }
    }
}

fileprivate extension RefreshableTableViewController {
    func getSearchableDataSource() -> SearchableDataSource<ItemType>? {
        return self.dataSource as? SearchableDataSource<ItemType>
    }
}
