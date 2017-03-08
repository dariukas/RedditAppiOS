//
//  DetailsViewController.swift
//  redditApp
//
//  Created by Kristina Šlekytė on 08/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    var item: Reddit?
    let store: CoreDataStore? = CoreDataStore()
    var isFavorite: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        //Issue ref: http://stackoverflow.com/questions/39520499/class-plbuildversion-is-implemented-in-both-frameworks
        loadWebViewContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setView() {
        titleLabel.text = item?.title
        isFavorite = store!.searchData((item?.title)!)
        //self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        if (isFavorite)! {
            editButton.setTitle("Remove", for: .normal)
        }
    }
    
    func loadWebViewContent() {
       
        guard let theItem = item as Reddit? else {
              return
        }
        
        let url = NSURL (string: ("http://www.reddit.com/\(theItem.permalink!)"))
        let requestObj = NSURLRequest(url: url! as URL)
        webView.loadRequest(requestObj as URLRequest)
    }
    
    
    // MARK: - Adding/Removing Favorites
    
    @IBAction func editButtonClicked(_ sender: Any) {
        guard let theItem = item
            else {
                return
        }
        if (isFavorite)! {
            store?.delete(theItem)
        } else {
            store?.save(theItem)
        }
    }
    
    //return -1 if not exist
//    func itemIndexInFavorites() -> Int {
//        guard let favorites: [Reddit] = UserDefaults.standard.value(forKey: "Favorites") as? Array<Reddit>, let theItem = item else {
//            return -1
//        }
//        if let index = favorites.index(of: theItem) {
//            return index
//        } else {
//            return -1
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
