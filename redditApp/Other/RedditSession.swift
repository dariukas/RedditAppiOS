//
//  RedditSession.swift
//  redditApp
//
//  Created by Kristina Šlekytė on 08/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class RedditSession: NSObject {
    
    class func getRequest(api: String, callback: @escaping ([String : AnyObject]?) -> ()){
        var request = URLRequest(url: URL(string: "http://www.reddit.com/\(api)")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("Error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    callback(json)
                } catch let error as NSError {
                    print(error)
                }
            }
        }).resume()
    }
}
