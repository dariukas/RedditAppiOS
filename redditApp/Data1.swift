//
//  Data.swift
//  redditApp
//
//  Created by Kristina Šlekytė on 07/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class Data1: NSObject {
    
    class func request1(){
        
        var request = URLRequest(url: URL(string: "http://www.reddit.com/top.json")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("Error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    print(json)
                    
                    //                    OperationQueue.main.addOperation({
                    //                        self.tableView.reloadData()
                    //                    })
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }).resume()
    }
    
    class func request2(callback: @escaping ([String : AnyObject]) -> ()){
        
        var request = URLRequest(url: URL(string: "http://www.reddit.com/top.json")!)
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
