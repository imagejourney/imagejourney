//
//  JournalViewController.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeJournalEntryViewControllerDelegate {
    
    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var journalAuthorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var composeNewEntryButton: UIBarButtonItem!
    
    var journal: Journal! {
        didSet {
            self.loadViewIfNeeded()
            journalTitleLabel.text = journal.title
            if let user = journal.author {
                journalAuthorLabel.text = "\(user.name ?? "anonymous")"
            }
            
            authorImageView.layer.cornerRadius = authorImageView.frame.size.width/2
            authorImageView.clipsToBounds = true
            if journal.author?.profileImageUrl != nil {
                authorImageView.setImageWith((journal.author?.profileImageUrl)!)
            } else {
                authorImageView.image = UIImage(named: "avatar-\(arc4random_uniform(6) + 1)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do not show compose new entry if journal view does not belong to current owner
        if journal.author?.username != User.getCurrentUser()?.username {
           self.navigationItem.rightBarButtonItem = nil
        }
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let entries = journal.entries {
            if entries.count > 0 {
                return entries.count
            }
        }
        tableView.backgroundView = Bundle.main.loadNibNamed("EmptyJournalView", owner: self, options: nil)?.first as! UIView?
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEntryCell") as! JournalEntryCell
        let entry = journal.entries?[indexPath.row]
        cell.entry = entry
        if let entries = journal.entries {
            cell.segmentPositionTuple = (indexPath.row, entries.count)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "journalToEntrySegue" {
            let journalEntryViewController = segue.destination as! JournalEntryViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            journalEntryViewController.entry = journal.entries?[indexPath!.row]
        } else if segue.identifier == "journalToComposeEntrySegue" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers.first as! ComposeEntryLocationPickerViewController
            vc.journal = journal
            vc.delegate = self
        }
    }
    
    // MARK: - ComposeJournalEntryViewControllerDelegate methods
    func didDismissComposeJournalEntryLocationPickerViewWithNewEntry() {
        journal.reloadJournalData()
        tableView.backgroundView?.isHidden = true
        tableView.reloadData()
    }

}
