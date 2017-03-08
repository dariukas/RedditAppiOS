//
//  DetailsViewController.swift
//  redditApp
//
//  Created by Kristina Šlekytė on 08/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    var item: Reddit?
    var indexOfFavorite: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexOfFavorite = itemIndexInFavorites()
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
        //self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        if (indexOfFavorite! > -1) {
            editButton.setTitle("Remove", for: .normal)
        }
    }
    
    func loadWebViewContent() {
        let url = NSURL (string: (item?.permalink)!)
        let requestObj = NSURLRequest(url: url! as URL)
        webView.loadRequest(requestObj as URLRequest)
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        guard indexOfFavorite! < 0, let theItem = item
            else {
                removeFavorite(indexOfFavorite!)
                return
        }
        addFavorite(theItem)
    }
    
    // MARK: - Adding/Removing Favorites
    
    func addFavorite(_ item: Reddit?) {
        guard var favorites: [Reddit] = UserDefaults.standard.value(forKey: "Favorites") as? Array<Reddit>, let theItem = item else {
            return
        }
        favorites.append(theItem)
        UserDefaults.standard.setValue(favorites, forKey: "Favorites")
    }
    
    //return -1 if not exist
    func itemIndexInFavorites() -> Int {
        guard let favorites: [Reddit] = UserDefaults.standard.value(forKey: "Favorites") as? Array<Reddit>, let theItem = item else {
            return -1
        }
        if let index = favorites.index(of: theItem) {
            return index
        } else {
            return -1
        }
    }
    
    func removeFavorite(_ index : Int) {
        var favorites: [Reddit] = UserDefaults.standard.value(forKey: "Favorites") as! [Reddit]
        favorites.remove(at: index)
        UserDefaults.standard.setValue(favorites, forKey: "Favorites")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
