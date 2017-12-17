//
//  FavoritesViewController.swift
//  Baby Names
//
//  Created by Maihan Nijat on 2017-11-01.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FavoritesViewController: CustomViewController {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        query = "true"
    }
    
    // Remove all names and get names again.
    // Refresh TableView and load Ad
    override func viewWillAppear(_ animated: Bool) {
        removeNames()
        getNames()
        tableView.reloadData()
        let bannerAd = Banner(adView: bannerView, parentController: self)
        bannerAd.loadAd(testing: false)
        bannerView.delegate = self
    }
    
    // Show ad view when ad is loaded
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerViewHeight.constant = 50
    }
    
    // Hide ad view when there is no ad
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerViewHeight.constant = 0
    }
    
    // Hide section titles on this view.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    // Hide section index titles for this view.
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    
    // Enable editing row to enable swipe delete.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // TableView editing function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let key = sortedSectionNames[indexPath.section]
            let nameArrays = filteredNames[key]
            let name = nameArrays![indexPath.row]
            
            // update database
            db.updateFavorite(id: name.id, value: "false")
            removeNames()
            getNames()
            tableView.reloadData()
        }
    }

}
