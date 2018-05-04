//
//  ProfileViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 03/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

class ProfileViewController: UIViewController, ProfileSectionProtocol, GenericDelegateDataSourceProtocol {
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate let sessionController = SessionController.init()
    
    fileprivate var dataSource: DataSource<String>!
    fileprivate lazy var itemsDataSource: GenericDelegateDataSource = {
        self.dataSource = DataSource<String>.init()
        self.dataSource.items = [ "Logout" ]
        let sections = [ ProfileSection.init(dataSource: self.dataSource) ]
        sections.forEach({$0.delegate = self})
        return GenericDelegateDataSource.init(withSections: sections, andTableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableViewDataSourceDelegate()
    }
    
    fileprivate func setupTableViewDataSourceDelegate() {
        self.tableView.delegate = self.itemsDataSource
        self.tableView.dataSource = self.itemsDataSource
        self.itemsDataSource.delegate = self
        self.tableView.reloadData()
    }
    
    // MARK: ProfileSectionProtocol
    
    func logoutUser() {
        self.sessionController.logout()
        if !(self.navigationController?.viewControllers.first is LoginViewController) {
            var vcs: [UIViewController] = self.navigationController?.viewControllers ?? []
            vcs.insert(LoginViewController.instantiate("LoginViewController")!, at: 0)
            self.navigationController?.setViewControllers(vcs, animated: false)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: GenericDelegateDataSourceProtocol
    
    func didSelectItem(at indexPath: IndexPath) {
        if self.tableView.cellForRow(at: indexPath) is LogoutCell {
            self.logoutUser()
        }
    }
}
