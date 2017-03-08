//
//  FavoritesViewController.swift
//  redditApp
//
//  Created by Kristina Šlekytė on 08/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var indicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    
    var favoriteItems: [Reddit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setView()
        activityIndicator()
        addRefreshControl()
        getList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //deselecting the cell
        if let path = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: path, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setView() {
        //self.title = "Favorites"
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath as IndexPath) as! CustomTableViewCell
        setCellData(&cell, item: favoriteItems[indexPath.row])
        return cell
    }
    
    func setCellData(_ cell: inout CustomTableViewCell, item: Reddit) {
        guard let link = item.thumbnailLink,
            let url = NSURL(string: link) else {
                return
        }
        if let data = NSData(contentsOf: url as URL) as? Data {
            cell.customImageView?.image = UIImage(data: data)
        }
        cell.customLabel?.text = item.title
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "showDetails", sender: self)
    }

    // MARK: UIRefreshControl
    
    func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh(refreshControl:)), for: .valueChanged)
        self.tableView.backgroundView = refreshControl // <- THIS!!!
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    //Ref: http://stackoverflow.com/questions/27030826/bug-with-scrollstotop-and-uirefreshcontrol
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        refreshControl.beginRefreshing()
        refreshControl.endRefreshing()
        return scrollView.scrollsToTop
    }
    
    func getList() {
        self.indicator.stopAnimating()
//        guard let store: CoreDataStore = CoreDataStore() else {
//            return
//        }
        let store: CoreDataStore = CoreDataStore()
        favoriteItems = store.fetchData()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let controller = segue.destination as! DetailsViewController
            if let path = self.tableView.indexPathForSelectedRow {
                controller.item = favoriteItems[path.row]
            }
        }
    }
    
    // MARK: UIActivityIndicatorView
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.color = UIColor.red
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.startAnimating()
    }
}
