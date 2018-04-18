//
//  RefreshableTableViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import PKHUD

class RefreshableTableViewController: UITableViewController {
    fileprivate weak var noContentViewController: NoContentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRefreshControl()
    }
    
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
    
    func startRefreshing() {
        self.removeNoContentBackgroundView()
        HUD.show(.progress)
    }
    
    func endRefreshing(with success: Bool) {
        HUD.flash(success ? .success : .error)
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: UIRefreshControl
    
    @objc fileprivate func refreshControl(sender: UIRefreshControl) {
        self.startRefreshing()
    }
}
