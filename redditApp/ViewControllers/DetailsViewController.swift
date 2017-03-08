//
//  DetailsViewController.swift
//  redditApp
//
//  Created by Darius Miliauskas on 08/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    
    var item: Reddit?
    let store: CoreDataStore? = CoreDataStore()
    var isFavorite: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        //Issue ref: http://stackoverflow.com/questions/39520499/class-plbuildversion-is-implemented-in-both-frameworks
        loadWebViewContent()
        webView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.progressView.setProgress(0.1, animated: false)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.progressView.setProgress(1.0, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.progressView.setProgress(1.0, animated: true)
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
