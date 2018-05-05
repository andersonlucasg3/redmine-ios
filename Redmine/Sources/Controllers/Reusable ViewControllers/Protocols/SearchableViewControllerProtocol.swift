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
    
    func setupDataSource(with items: [SearchableType]) {
        let dataSource = SearchableDataSource(items)
        if let searchController = self.searchController {
            dataSource.performSearch(searchController.searchBar.text)
        }
        
        var sections: [Section] = [SectionType(dataSource: dataSource)]
        if self.pageCounter?.hasNextPage ?? false {
            let dts = DataSource<String>.init()
            dts.items = ["LoadMore"]
            sections.append(LoadMoreSection.init(dataSource: dts))
        }
        
        self.dataSource = dataSource
        self.delegateDataSource = GenericDelegateDataSource(withSections: sections, andTableView: self.tableView)
        
        self.tableView.delegate = self.delegateDataSource
        self.tableView.dataSource = self.delegateDataSource
        self.delegateDataSource.delegate = self
    }
    
    func setupDataSourceIfPossible(with items: [SearchableType]) {
        if let _ = self.tableView, items.count > 0 {
            self.setupDataSource(with: items)
        } else {
            self.showNoContentBackgroundView()
        }
    }
    
    func updateSearch(for controller: UISearchController) {
        self.dataSource?.performSearch(self.searchController?.searchBar.text)
        self.reloadTableView()
    }
}


