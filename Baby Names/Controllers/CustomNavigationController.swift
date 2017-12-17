//
//  CustomNavigationController.swift
//  Baby Names
//
//  Created by Maihan Nijat on 2017-11-08.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit

class CustomNavigationController: UIViewController {
    
    var searchController: UISearchController!
    var resultTableController: UITableViewController!
    var searchBar: UISearchBar!
    
    //MARK: - Search Controller
    override func viewDidLoad(){
        super.viewDidLoad()
        // Assign TableController to SearchController
        searchController = UISearchController(searchResultsController: resultTableController)
        // Show NavigationController in presentation view.
        searchController.hidesNavigationBarDuringPresentation = false
        // Hide dims overlay while searching
        searchController.dimsBackgroundDuringPresentation = false
        
        //MARK: - Navigation Controller
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationController?.navigationBar.backgroundColor = UIColor.orange
        // Hide a narrow line between NavigationController and SearchBar
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //MARK: - Search Bar
        searchBar = searchController.searchBar
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        searchBar.barTintColor = UIColor.orange
        searchBar.backgroundImage = UIImage()
        searchBar.returnKeyType = .done
        searchBar.placeholder = NSLocalizedString("Search", comment: "Search bar hint")
        
        // Add searchBar as SubView of NavigationController
        view.addSubview(searchBar)
        
        // Flexible SearchBar width for different screen sizes.
        // Fix full width problem
        searchBar.autoresizesSubviews = true
        searchBar.autoresizingMask = .flexibleWidth
    }
}
