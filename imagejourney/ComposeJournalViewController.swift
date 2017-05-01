//
//  ComposeJournalViewController.swift
//  imagejourney
//
//  Created by Sophia on 4/30/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit

class ComposeJournalViewController: UIViewController {

    var entries: [JournalEntry]? = []
    var previewImageUrls: [URL]? = []
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateJournal(_ sender: UIBarButtonItem) {
        if titleTextField.text != nil && (titleTextField.text?.trimmingCharacters(in: .whitespaces).characters.count)! > 0 {
            ParseClient.sharedInstance.saveJournal(title: titleTextField.text!, entries: entries!, previewImageUrls: previewImageUrls!)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
