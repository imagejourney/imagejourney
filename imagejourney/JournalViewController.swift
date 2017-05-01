//
//  JournalViewController.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/29/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var journalAuthorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var journal: Journal! {
        didSet {
            self.loadViewIfNeeded()
            tableView.delegate = self
            tableView.dataSource = self
            journalTitleLabel.text = journal.title
            if let user = journal.author {
                journalAuthorLabel.text = "by \(user.name)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let entries = journal.entries {
            return entries.count
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEntryCell") as! JournalEntryCell
        let entry = journal.entries?[indexPath.row]
        cell.entry = entry
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let journalEntryViewController = segue.destination as! JournalEntryViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        journalEntryViewController.entry = journal.entries?[indexPath!.row]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
