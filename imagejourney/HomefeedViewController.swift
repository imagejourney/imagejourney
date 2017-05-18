//
//  HomefeedViewController.swift
//  imagejourney
//
//  Created by Sophia on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit
import SidebarOverlay
import Material
import SwiftSpinner

class HomefeedViewController: SOContainerViewController, UITableViewDelegate, UITableViewDataSource, ComposeJournalViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var journals: [Journal]? = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchJournals()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // table view defaults
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 380
        
        // fetch journals
        fetchJournals()
        
        self.menuSide = .left
        self.sideViewController = Helper.getMenuController()
        self.sideMenuWidth = Constants.MENU_WIDTH
        
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.THEME_COLOR
        for item in self.navigationItem.rightBarButtonItems! {
            item.tintColor = Constants.THEME_COLOR
        }
        self.navigationController?.navigationBar.tintColor = Constants.THEME_COLOR
    }
    
    func fetchJournals() {
        // Fetch journals to show
        SwiftSpinner.show(Constants.HOMEFEED_FETCHING_MSG)
        ParseClient.sharedInstance.getJournalsWithCompletion(currentUserOnly: false, completion: { (journals: [Journal]?) in
            if journals != nil {
                self.journals = journals
                self.tableView.reloadData()
            } else {
                print("journals fetch failed")
            }
            SwiftSpinner.hide()
        })
    }
    
    @IBAction func showMenu(_ sender: Any) {
        self.isSideViewControllerPresented = !self.isSideViewControllerPresented
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell") as! JournalCell
        let journal = journals?[indexPath.row]
        cell.buildCellWithJournal(journal: journal!)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (journals?.count)!
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homefeedToJournalSegue" {
            let journalViewController = segue.destination as! JournalViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            journalViewController.journal = journals?[indexPath!.row]
        } else if segue.identifier == "homefeedToComposeJournalSegue" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers.first as! ComposeJournalViewController
            vc.delegate = self
        } else if segue.identifier == "homefeedToNewJournalSegue" {
            let journalViewController = segue.destination as! JournalViewController
            journalViewController.journal = sender as! Journal
        } else if segue.identifier == "homefeedMapViewSegue" {
            let mapViewController = segue.destination as! MapViewController
            mapViewController.journals = self.journals
        }
    }
    
    // MARK: - ComposeJournalViewControllerDelegate methods 
    func didDismissComposeJournalViewWithNewJournal(journal: Journal) {
        journals?.append(journal)
        tableView.reloadData()
        self.performSegue(withIdentifier: "homefeedToNewJournalSegue", sender: journal)
    }
}
