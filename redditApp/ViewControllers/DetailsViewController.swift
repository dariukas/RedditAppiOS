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
    @IBOutlet weak var webView: UIWebView!
    
    var item: Reddit?
    
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
        self.title = item?.title
        //self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    func loadWebViewContent() {
        let url = NSURL (string: (item?.permalink)!)
        let requestObj = NSURLRequest(url: url! as URL)
        webView.loadRequest(requestObj as URLRequest)
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
