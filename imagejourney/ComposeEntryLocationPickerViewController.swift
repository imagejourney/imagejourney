//
//  ComposeEntryLocationPickerViewController.swift
//  imagejourney
//
//  Created by Sophia on 5/7/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import MapKit
import Parse
import UIKit
import Material
import Photos
import OpalImagePicker
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import MBAutoGrowingTextView
import SwiftSpinner

protocol ComposeJournalEntryViewControllerDelegate: class {
    func didDismissComposeJournalEntryLocationPickerViewWithNewEntry()
}

class ComposeEntryLocationPickerViewController: UIViewController,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,OpalImagePickerControllerDelegate {
    var datePicker: UIDatePicker!
    var datePickerToolBar: UIToolbar!
    var weather:String? = ""
    var showingDatePicker: Bool! = false
    var weatherPickerData: [String]! = ["Sunny", "Cloudy", "Rain", "Snow"]
    var journal: Journal!
    var images: [UIImage]! = []
    var imagePicker:OpalImagePickerController?
    var delegate: ComposeJournalEntryViewControllerDelegate?
    var coordinate: CLLocationCoordinate2D?
    let IMAGE_SELECT_LIMIT = 9
    let IMAGE_ROW_HEIGHT = 120
    let IMAGE_ROW_BOTTOM_MARGIN = 5
    let TEXT_PLACEHOLDER_COLOR = Helper.UIColorFromHex(rgbValue: 0xaaaaaa, alpha: 1.0)
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var imageCollection: UICollectionView!
    @IBOutlet var imageCollectionHeight: NSLayoutConstraint!
    @IBOutlet var travelLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var titleText: TextField!
    @IBOutlet var descriptionText: MBAutoGrowingTextView!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var weatherView: UIView!
    
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onComposeJournalEntryComplete(_ sender: UIBarButtonItem) {
        if (coordinate == nil || images.isEmpty) {
            showErrorAlert()
            return
        }
        
        SwiftSpinner.show(Constants.SAVING_JOURNAL_ENTRY_MSG)
        ParseClient.sharedInstance.saveEntries(images: images, weather: weather!, date: datePicker.date, description: descriptionText.text,title: titleText.text, coordinate: coordinate!, toJournal: journal, completion: { () in
            self.delegate?.didDismissComposeJournalEntryLocationPickerViewWithNewEntry()
            self.dismiss(animated: true, completion: nil)
            SwiftSpinner.hide()
        })
    }
    
    func showErrorAlert() {
        var errorInfo:Dictionary<String,String> = [:]
        if (coordinate == nil){
            errorInfo = [
                "title" : "No Location",
                "message": "Please pick a location for your journal"
            ]
        }
        if (images.isEmpty){
            errorInfo = [
                "title" : "No photos",
                "message": "Please pick at least one image to upload"
            ]
        }
        let alertController = UIAlertController(title: errorInfo["title"], message: errorInfo["message"], preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == TEXT_PLACEHOLDER_COLOR {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.setTextViewPlaceholder()
        }
    }
    
    func setTextViewPlaceholder(){
        textView.text = "Share some interesting moments or findings!"
        textView.textColor = TEXT_PLACEHOLDER_COLOR
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var number = self.images.count
        if number < IMAGE_SELECT_LIMIT{
            number = number + 1
        }
        let lines = number / 3
        let lines_mod = number % 3
        if lines_mod == 0 {
            imageCollectionHeight.constant = CGFloat(lines * IMAGE_ROW_HEIGHT + (lines - 1) * IMAGE_ROW_BOTTOM_MARGIN)
        }else{
            imageCollectionHeight.constant = CGFloat((lines + 1) * IMAGE_ROW_HEIGHT + lines * IMAGE_ROW_BOTTOM_MARGIN)
        }
        return number
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        present(imagePicker!, animated: true, completion: nil)
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        self.images = images
        self.imageCollection.reloadData()
        picker.dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCell", for: indexPath) as! ImageCollectionViewCell
        let row = indexPath.row
        if row < self.images.count{
            cell.selectedImageView.image = self.images[row]
            cell.defaultImageView.isHidden = true
            cell.selectedImageView.isHidden = false
        } else {
            cell.selectedImageView.isHidden = true
            cell.defaultImageView.isHidden = false
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        setTextViewPlaceholder()
        setUpImagePicker()
        setUpCalendarPicker()
        setUpLabelTap()
    }
    
    func onAddDestination(_ sender: Any) {
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
            self.coordinate = place.coordinate
            self.locationLabel.text = place.formattedAddress
        })
    }

    @IBAction func onWeatherSelect(_ sender: UIButton) {
        let weatherTxt = (sender.titleLabel?.text)! as String
        weather = weatherTxt
        weatherLabel.text = weatherTxt
        weatherLabel.isHidden = false
        weatherView.isHidden = true
    }
    
    func onCalendar(_ sender: Any) {
        if showingDatePicker == true {
            return
        }
        
        showingDatePicker = true
        
        self.view.addSubview(datePicker)
        
        datePickerToolBar = UIToolbar.init(frame: CGRect(x: 0, y: self.view.height - 200 - 40, width: self.view.width, height: 40))
        datePickerToolBar.backgroundColor = UIColor.white
        datePickerToolBar.tintColor = Constants.THEME_COLOR
        let doneButton = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(removeDatePicker));
        datePickerToolBar.setItems([doneButton], animated: true)
        self.view.addSubview(datePickerToolBar)
    }
    
    func onWeather(_ sender:Any) {
        UIView.animate(withDuration: 1, animations: {
            self.weatherView.isHidden = false
            self.weatherLabel.isHidden = true
        })
    }
    
    func removeDatePicker() {
        showingDatePicker = false
        self.datePickerToolBar.removeFromSuperview()
        self.datePicker.removeFromSuperview()
    }
    
    func updateDateLabelTitle() {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = String.localizedStringWithFormat("%@", dateFormatter.string(from: datePicker.date))
        self.travelLabel.text = dateString
    }
    
    func setUpImagePicker() {
        imagePicker = OpalImagePickerController()
        imagePicker?.imagePickerDelegate = self
        imagePicker?.maximumSelectionsAllowed = IMAGE_SELECT_LIMIT
        imagePicker?.selectionTintColor = Constants.THEME_COLOR_TWO
        imagePicker?.selectionImage = UIImage(named: "check-blue")
    }
    
    func setUpCalendarPicker(){
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: self.view.height - 200, width: self.view.width, height: 200))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date;
        datePicker.isHidden = false;
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(updateDateLabelTitle), for: UIControlEvents.valueChanged)
    }
    
    func setUpLabelTap(){
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(self.onAddDestination))
        let calendarTap = UITapGestureRecognizer(target: self, action: #selector(self.onCalendar))
        let weatherTap = UITapGestureRecognizer(target: self, action: #selector(self.onWeather))
        locationLabel.addGestureRecognizer(locationTap)
        travelLabel.addGestureRecognizer(calendarTap)
        weatherLabel.addGestureRecognizer(weatherTap)
    }
}

