//
//  MainViewController.swift
//  redditApp
//
//  Created by Kristina Šlekytė on 08/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var indicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    
    var items: [Reddit] = []
    var after: String?
    var filteredItems: [Reddit] = []
    var cache: [Reddit] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        activityIndicator()
        addRefreshControl()
        getList("top.json")
        //        Data1.request2() { (response) in
        //                        print(response)
        //                }
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
        self.title = "Reddit List"
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath as IndexPath) as! TopTableViewCell
        //        var cell : CustomTableViewCell = CustomTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "topCell")
        setCellData(&cell, item: items[indexPath.row])
        return cell
    }
    
    func setCellData(_ cell: inout TopTableViewCell, item: Reddit) {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = items.count - 2
        if indexPath.row == lastElement {
            if let name = self.after {
                getList("top.json?after=\(name)")
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "showDetails", sender: self)
//    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching(searchBar)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        filteredItems = []
        items = cache
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching(searchBar)
    }
    
    func searching(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            let search = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if (search.characters.count > 2) {
                filterData(search.lowercased()) //not case sensitive
                items = filteredItems
                tableView.reloadData()
                filteredItems = [] //to avoid duplications of result
            }
        }
    }
    
    func filterData(_ search: String) {
        for item in cache {
            //not case sensitive
            if let title = item.title {
                //Ref: http://stackoverflow.com/questions/24034043/how-do-i-check-if-a-string-contains-another-string-in-swift
                if title.lowercased().range(of:search) != nil {
                    filteredItems.append(item)
                }
            }
        }
    }
    
    // MARK: UIRefreshControl
    
    func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh(refreshControl:)), for: .valueChanged)
        self.tableView.backgroundView = refreshControl // <- THIS!!!
        //fetchFixtures()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        //fetchFixtures()
        refreshControl.endRefreshing()
    }
    
    //Ref: http://stackoverflow.com/questions/27030826/bug-with-scrollstotop-and-uirefreshcontrol
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        refreshControl.beginRefreshing()
        refreshControl.endRefreshing()
        return scrollView.scrollsToTop
    }
    
    func getList(_ api: String) {
        Reddit.getRedditList(api: api) { (results, result) in
            self.cache.append(contentsOf: results)
            self.after = result
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                //self.indicator.isHidden = true
                self.items = self.cache
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let controller = segue.destination as! DetailsViewController
            if let path = self.tableView.indexPathForSelectedRow {
                controller.item = items[path.row]
                //controller.selected = path.row
            }
        }
    }
    
    // MARK: UIActivityIndicatorView
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        //indicator = UIActivityIndicatorView(frame: CGRect(x: 5.0, y:5.0, width:view.frame.size.width/2, height:view.frame.size.height/2))
        //indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.color = UIColor.red
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.startAnimating()
    }

}
