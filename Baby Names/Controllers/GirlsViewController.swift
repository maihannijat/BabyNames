//
//  GirlsViewController.swift
//  Baby Names
//
//  Created by Maihan Nijat on 2017-11-01.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GirlsViewController: CustomViewController {

    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // Assign "female" value to query to get boys name only
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        query = "female"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bannerAd = Banner(adView: bannerView, parentController: self)
        bannerAd.loadAd(testing: false)
        bannerView.delegate = self
    }
    
    // Show the ad view when ad is recieved
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerViewHeight.constant = 50
    }
    
    // Hide the ad view when there is no ad
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerViewHeight.constant = 0
    }
}
