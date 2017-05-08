//
//  SearchViewController.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit
import SidebarOverlay

class SearchViewController: SOContainerViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var journals: [Journal]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
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
        let query = searchBar.text! as String
        ParseClient.sharedInstance.searchByJournalTitle(searchText: query) { (journals) in
            self.journals = journals
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
        print("num cells \(journals?.count ?? 0)")
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
