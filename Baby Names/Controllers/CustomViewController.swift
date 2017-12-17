//
//  CustomNavBar.swift
//  Baby Names
//
//  Created by Maihan Nijat on 2017-11-01.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CustomViewController: CustomNavigationController, UISearchResultsUpdating,UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    let db = DatabaseManager()
    var sortedSectionNames: [String] = []
    var namesDictionary = [String: [Name]]()
    var filteredNames = [String: [Name]]()
    var query: String!
    var tableView: UITableView!
    
    @IBOutlet weak var boysTableView: UITableView!
    @IBOutlet weak var girlsTableView: UITableView!
    @IBOutlet weak var favoritesTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign the tableView based on the tab
        if query == "male" {
            tableView = boysTableView
        } else if query == "female" {
            tableView = girlsTableView
        } else if query == "true" {
            tableView = favoritesTableView
        }
        
        if tableView != favoritesTableView {
            getNames()
        }
        
        searchController.searchResultsUpdater = self
    }
    
    //MARK: - Get Names
    // Get names from database with query parameter.
    func getNames() {
        namesDictionary = Dictionary(grouping: db.getNames(query: query), by: { String($0.name.first!) })
        filteredNames = namesDictionary
        sortedSectionNames = sortSectionNames()
    }
    //MARK: - Remove Names
    // Remove all data from arrays and refresh table view.
    func removeNames(){
        namesDictionary.removeAll()
        filteredNames.removeAll()
        sortedSectionNames.removeAll()
    }
    
    //MARK: - Sort Section Names
    // Match section names array with names dictionary and remove elements from section names which doesn't exist in dictionary keys.
    func sortSectionNames() -> [String] {
        
        let sectionNames = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","Y","Z"]
        
        for sectionName in sectionNames {
            if filteredNames.keys.contains(sectionName) {
                sortedSectionNames.append(sectionName)
            }
        }
        
        return sortedSectionNames.sorted { $0 < $1 }
    }
    
    //MARK: - Update Search Result
    func updateSearchResults(for searchController: UISearchController) {
        
        sortedSectionNames.removeAll()
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        
        // Return full array when search bar has no text
        // Re-assign the values to have full list after search cancelled
        if searchController.searchBar.text! == "" {
            filteredNames = namesDictionary
            sortedSectionNames = sortSectionNames()
        } else {
            filteredNames.removeAll()
            
            // Create names array to add all names from database
            let namesArray = db.getNames(query: query)
            
            // Filter array based on text in search bar.
            // Search for names which has "%text%" anywhere.
            let namesFilteredArray = namesArray.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) || $0.native.contains(searchController.searchBar.text!)
            }
            
            filteredNames = Dictionary(grouping: namesFilteredArray, by: { String($0.name.first!) })
            
            sortedSectionNames = sortSectionNames()
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.contentInset = UIEdgeInsetsMake(45,0,0,0);
        return sortedSectionNames.count
    }
    
    //MARK: - Title for Sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Do not show section names while searching
        if searchController.isActive    {
            return nil
        } else { return sortedSectionNames[section] }
    }
    
    //MARK: - Section Index Titles
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // Do not show section index titles while searching
        if searchController.isActive    {
            return nil
        } else { return sortedSectionNames }
    }
    
    //MARK: - Number of Rows in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (filteredNames[sortedSectionNames[section]]?.count)!
    }
    
    //Mark: - Display Cell Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Set initial value
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    //MARK: - Cell for Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let key = sortedSectionNames[indexPath.section]
        let nameArrays = filteredNames[key]
        let name = nameArrays![indexPath.row]
        
        cell.textLabel?.text = name.name
        cell.detailTextLabel?.text = name.native
        return cell
    }
    
    //MARK: - Did Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    //MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass search bar and name object to detail view controller
        if segue.identifier == "detail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailViewController = segue.destination as! DetailViewController
                
                let key = sortedSectionNames[indexPath.section]
                let nameArrays = filteredNames[key]
                
                detailViewController.nameObject = nameArrays![indexPath.row]
                detailViewController.searchBar = searchBar
            }
        }
    }
}
