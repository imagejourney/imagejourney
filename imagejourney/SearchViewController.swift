//
//  SearchViewController.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit
import SidebarOverlay
import Material
import MapKit
import SwiftSpinner

class SearchViewController: SOContainerViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var journals: [Journal]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        
        self.menuSide = .left
        self.sideViewController = Helper.getMenuController()
        self.sideMenuWidth = Constants.MENU_WIDTH
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) // called when keyboard search button pressed
    {
        self.performSearch()
    }
    
    func performSearch() {
        self.journals = []
        let query = searchBar.text! as String
        var isTitleSearchFinished = false
        var isLocationSearchFinished = false
        self.view.endEditing(true)
        SwiftSpinner.show(Constants.SEARCHING_MSG)
        ParseClient.sharedInstance.searchByJournalTitle(searchText: query) { (journals) in
            if !(journals?.isEmpty)!{
                var journalArray = self.journals! + journals!
                journalArray = journalArray.filter {(journal) in journal.author?.username != User.getCurrentUser()?.username}
                self.journals = journalArray
                self.tableView.reloadData()
            }
            isTitleSearchFinished = true
            if isTitleSearchFinished && isLocationSearchFinished {
                SwiftSpinner.hide()
            }
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(query, completionHandler: { (clPlacemarkArray, error) in
            if (clPlacemarkArray?.count ?? 0) > 0 {
                if let coord = clPlacemarkArray?[0].location?.coordinate {
                    ParseClient.sharedInstance.searchByJournalLocation(lat: coord.latitude, long: coord.longitude, completion: { (journals) in
                        if !(journals?.isEmpty)!{
                            var journalArray = self.journals! + journals!
                            journalArray = journalArray.filter {(journal) in journal.author?.username != User.getCurrentUser()?.username}
                            self.journals = journalArray
                            self.tableView.reloadData()
                        }
                        isLocationSearchFinished = true
                        if isTitleSearchFinished && isLocationSearchFinished {
                            SwiftSpinner.hide()
                        }
                    })
                }
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.journals = []
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! SearchResultCell
        let journal = journals?[indexPath.row]
        cell.journal = journal
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journals?.count ?? 0
    }
    
    @IBAction func onMenuTap(_ sender: Any) {
        self.isSideViewControllerPresented = !self.isSideViewControllerPresented
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToJournalSegue" {
            let journalViewController = segue.destination as! JournalViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            journalViewController.journal = journals?[indexPath!.row]
        }
    }

}
