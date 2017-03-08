//
//  Reddit.swift
//  redditApp
//
//  Created by Darius Miliauskas on 08/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class Reddit: NSObject {
    
    var title: String?
    var thumbnailLink: String?
    var permalink: String?
    
    class func getRedditList(api: String, handler: @escaping ([Reddit], String) -> ()){
        //var api : String = "top.json"
        //UserDefaults.standard.value(forKey: "after") as? String
        //UserDefaults.standard.setValue(nil, forKey: "after")        
        RedditSession.getRequest(api: api) { (response) in
            guard let item : [String: AnyObject] = response,
                let data = item["data"] as? [String : AnyObject],
                let children = data["children"] as? [AnyObject] else {
                    return
            }
            
            //for pagination, not always necessary
            guard let after = data["after"] as? String else {
                return
            }
            
            handler(itemsToReddits(children), after)
        }
    }

    class func itemsToReddits(_ items : [AnyObject]) -> [Reddit] {
        var redditArray = [Reddit]()
        for item in items {
            //Ref: https://www.raywenderlich.com/150322/swift-json-tutorial-2
            guard let data = item["data"] as? [String : AnyObject],
                let title = data["title"] as? String,
                let permalink = data["permalink"] as? String,
                let thumbnail = data["thumbnail"] as? String else {
                    return redditArray
            }
            let reddit = Reddit()
            reddit.title = title
            reddit.thumbnailLink = thumbnail
            reddit.permalink = permalink
            redditArray.append(reddit)
        }
        return redditArray
    }

}
