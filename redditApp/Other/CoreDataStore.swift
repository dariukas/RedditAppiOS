//
//  CoreDataStore.swift
//  redditApp
//
//  Created by Kristina Šlekytė on 08/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStore: NSObject {
    
    var favorites: [NSManagedObject] = []
    
    func save(_ item: Reddit) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Favorite",
                                       in: managedContext)!
        let favorite = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        favorite.setValue(item.title, forKeyPath: "title")
        favorite.setValue(item.thumbnailLink, forKeyPath: "thumbnailLink")
        favorite.setValue(item.permalink, forKeyPath: "permalink")
        do {
            try managedContext.save()
            favorites.append(favorite)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete(_ item: Reddit) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        guard let title = item.title else {
             return
        }
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS %@", title)
        
        do {
            favorites = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
            if (favorites.count>0) {
               managedContext.delete(favorites.first!)
            }
        } catch {
            print("Error.")
        }
    }
    
    func fetchData() -> [Reddit] {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        
        var redditArray = [Reddit]()
        do {
            favorites = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for favorite in favorites {
            let reddit = Reddit()
            reddit.title = favorite.value(forKey: "title") as! String?
            reddit.thumbnailLink = favorite.value(forKey: "thumbnailLink") as! String?
            reddit.permalink = favorite.value(forKey: "permalink") as! String?
            redditArray.append(reddit)
        }
        return redditArray
    }
    
    func searchData(_ title: String) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
    
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        request.predicate = NSPredicate(format: "title CONTAINS %@", title)
        do {
            favorites = try managedContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
        } catch {
            print("Error.")
        }
        return favorites.count>0
    }
    
//    func getManagedContext() -> NSManagedObjectContext {
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return nil
//        }
//        return appDelegate.persistentContainer.viewContext
//    }
}
