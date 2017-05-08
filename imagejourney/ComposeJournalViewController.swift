//
//  ComposeJournalViewController.swift
//  imagejourney
//
//  Created by Sophia on 4/30/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit

protocol ComposeJournalViewControllerDelegate: class {
    func didDismissComposeJournalViewWithNewJournal(journal: Journal)
}

class ComposeJournalViewController: UIViewController {

    var entries: [JournalEntry]? = []
    var previewImageUrls: [URL]? = []
    var delegate: ComposeJournalViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateJournal(_ sender: UIBarButtonItem) {
        if titleTextField.text != nil && (titleTextField.text?.trimmingCharacters(in: .whitespaces).characters.count)! > 0 {
            ParseClient.sharedInstance.saveJournal(title: titleTextField.text!, entries: entries!, previewImageUrls: previewImageUrls!, completion: { (pfJournalObj: PFObject) in
                // On success of saving object to Parse, create Journal object from the PFObject we saved and pass it delegate method in HFVC which
                // will  segue to after dismissing the Journal creation modal
                let newJournal = Journal.init(obj: pfJournalObj)
                self.dismiss(animated: true, completion: {self.delegate?.didDismissComposeJournalViewWithNewJournal(journal: newJournal)})
            })
        } else {
            showErrorAlert()
        }
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Empty title", message: "Please enter a title for your Journal!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // do nothing, just let alert dismiss
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
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
