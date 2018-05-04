//
//  SearchableViewControllerProtocol.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

protocol SearchableViewControllerProtocol: class {
    associatedtype SearchableType: Searchable
    associatedtype SectionType: Section
    
    var tableView: UITableView! { get }

    var searchController: UISearchController! { get set }
    
    var dataSource: SearchableDataSource<SearchableType>! { get set }
    var delegateDataSource: GenericDelegateDataSource! { get set }
}

extension SearchableViewControllerProtocol where Self : RefreshableTableViewController, Self : UISearchResultsUpdating {
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Projects"
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
    
    func setupDataSourceIfPossible(with items: [SearchableType]) {
        if let tableView = self.tableView, items.count > 0 {
            let dataSource = SearchableDataSource(items)
            if let searchController = self.searchController {
                dataSource.performSearch(searchController.searchBar.text)
            }
            
            let sections = [SectionType(dataSource: dataSource)]
            self.delegateDataSource = GenericDelegateDataSource(withSections: sections, andTableView: tableView)
            
            tableView.delegate = self.delegateDataSource
            tableView.dataSource = self.delegateDataSource
            
            self.dataSource = dataSource
        } else {
            self.showNoContentBackgroundView()
        }
    }
    
    func updateSearch(for controller: UISearchController) {
        self.dataSource?.performSearch(self.searchController?.searchBar.text)
        self.reloadTableView()
    }
}


