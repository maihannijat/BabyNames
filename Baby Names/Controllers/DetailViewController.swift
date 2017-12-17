//
//  DetailViewController.swift
//  Baby Names
//
//  Created by Maihan Nijat on 2017-11-02.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DetailViewController: UIViewController, GADInterstitialDelegate {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var native: UILabel!
    @IBOutlet weak var meaningView: UIView!
    @IBOutlet weak var originView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var meaning: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var genderIcon: UIImageView!
    
    var nameObject: Name!
    var searchBar: UISearchBar!
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView(view: nameView)
        customView(view: meaningView)
        customView(view: originView)
        
        name.text = nameObject.name
        native.text = nameObject.native
        meaning.text = nameObject.meaning
        origin.text = nameObject.origin
        
        // Change gender icon based on name gender
        if nameObject.gender == "male" {
            genderIcon.image = UIImage(named: "gender-male")
        } else if nameObject.gender == "female" {
            genderIcon.image = UIImage(named: "gender-female")
        }
        
        // Hide the search bar on this view
        searchBar.endEditing(true)
        searchBar.isHidden = true
        
        // Load ad
        interstitialAd()
    }
    
    // Load full screen ad
    func interstitialAd(){
        let request = GADRequest()
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6404264627814552/4073500908")
        request.testDevices = ["b285e2de2a9acf7444baa910e45c61e5"]
        interstitial.load(request)
        interstitial.delegate = self
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    // Custom view to add orange border around rectangles
    func customView(view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.cornerRadius = 15
        // Add shadow to the view
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.2
    }
    
    // Show the searchBar when returning from this view
    override func viewWillDisappear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    // Ad or remove a name to the favorite list
    @IBAction func setFavorite(_ sender: UIBarButtonItem) {
        let db = DatabaseManager()
        db.updateFavorite(id: nameObject.id, value: "true")
        
        let alert = UIAlertController(title: "Successful", message: "The name is added to favorite list.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // Share function which loads Activity View Controller
    @IBAction func share(_ sender: UIBarButtonItem) {
        
        let textToShare = [ ("Name:  \(nameObject.name), Native: \(nameObject.native), Meaning: (\(nameObject.meaning)), Gender: \(nameObject.gender)") ]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)

    }
}
