//
//  ComposeJournalViewController.swift
//  imagejourney
//
//  Created by Sophia on 4/30/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit
import Material
import GooglePlaces
import GoogleMaps
import GooglePlacePicker

protocol ComposeJournalViewControllerDelegate: class {
    func didDismissComposeJournalViewWithNewJournal(journal: Journal)
}

class ComposeJournalViewController: UIViewController {
    var longtitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    var entries: [JournalEntry]? = []
    var delegate: ComposeJournalViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: TextField!
    @IBOutlet weak var descriptionTextField: TextField!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateJournal(_ sender: UIBarButtonItem) {
        if titleTextField.text != nil && (titleTextField.text?.trimmingCharacters(in: .whitespaces).characters.count)! > 0 {
            ParseClient.sharedInstance.saveJournal(title: titleTextField.text!, desc:descriptionTextField.text!, longtitude:longtitude, latitude: latitude, entries: entries!, completion: { (pfJournalObj: PFObject) in
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
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = backgroundView.bounds
        gradient.colors = [Constants.BG_GRADIENT_BLUE.cgColor, Constants.BG_GRADIENT_GREEN.cgColor, Constants.BG_GRADIENT_AQUA.cgColor]
        gradient.locations = [0.5, 0.8, 1.0]
        backgroundView.layer.insertSublayer(gradient, at: 0)
        
        let titleLeftView = UIImageView()
        titleLeftView.image = UIImage(named: "camera")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        titleLeftView.tintColor = Constants.THEME_COLOR
        titleTextField.leftView = titleLeftView
        
        let descLeftView = UIImageView()
        descLeftView.image = UIImage(named: "trip")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        descLeftView.tintColor = Constants.THEME_COLOR
        descriptionTextField.leftView = descLeftView
        
        titleTextField.becomeFirstResponder()
    }

    @IBAction func pickPlace(_ sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: { (place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place selected")
                return
            }
            self.longtitude = place.coordinate.longitude
            self.latitude = place.coordinate.latitude
            self.locationLabel.isHidden = false
            self.locationLabel.text = place.formattedAddress
        })
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
