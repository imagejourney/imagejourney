//
//  ProfileViewController.swift
//  imagejourney
//
//  Created by Sophia on 4/30/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import AFNetworking
import UIKit
import SidebarOverlay

class ProfileViewController: SOContainerViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var journalCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User = User.getCurrentUser()!
    var journals: [Journal]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 380
        
        if user.profileImageUrl != nil {
            profileImageView.setImageWith(user.profileImageUrl!)
        } else {
            profileImageView.image = #imageLiteral(resourceName: "default_profile_image")
        }
        
        profileNameLabel.text = user.name
        journalCountLabel.text = "0 journals"
        
        // Fetch journals to show
        ParseClient.sharedInstance.getJournalsWithCompletion(currentUserOnly: true, completion: { (journals: [Journal]?) in
            if journals != nil {
                self.journals = journals
                self.journalCountLabel.text = "\(journals?.count ?? 0) journals"
                self.tableView.reloadData()
            } else {
                print("journals fetch failed")
            }
        })
        
        self.menuSide = .left
        self.sideViewController = Helper.getMenuController()
        self.sideMenuWidth = Constants.MENU_WIDTH
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell") as! JournalCell
        let journal = journals?[indexPath.row]
        cell.buildCellWithJournal(journal: journal!)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    @IBAction func showMenu(_ sender: Any) {
         self.isSideViewControllerPresented = !self.isSideViewControllerPresented
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (journals?.count)!
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToJournalSegue" {
            let journalViewController = segue.destination as! JournalViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            journalViewController.journal = journals?[indexPath!.row]
        }
    }

}
