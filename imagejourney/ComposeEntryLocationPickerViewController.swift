//
//  ComposeEntryLocationPickerViewController.swift
//  imagejourney
//
//  Created by Sophia on 5/7/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import MapKit
import UIKit

class ComposeEntryLocationPickerViewController: UIViewController, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var datePicker: UIDatePicker!
    var datePickerToolBar: UIToolbar!
    var showingDatePicker: Bool! = false
    var weatherPickerData: [String]! = ["Sunny", "Cloudy", "Rain", "Snow"]
    
    // Search bar/map vars
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!

    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var weatherPicker: UIPickerView!
  
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func onTapDateLabel(_ sender: UITapGestureRecognizer) {
        if showingDatePicker {
            return
        }
        
        showingDatePicker = true
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: self.view.height - 200, width: self.view.width, height: 200))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date;
        datePicker.isHidden = false;
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(updateDateLabelTitle), for: UIControlEvents.valueChanged)
        self.view.addSubview(datePicker)
        
        datePickerToolBar = UIToolbar.init(frame: CGRect(x: 0, y: self.view.height - 200 - 40, width: self.view.width, height: 40))
        datePickerToolBar.backgroundColor = UIColor.white
        datePickerToolBar.tintColor = UIColor.blue
        let doneButton = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(removeDatePicker));
        datePickerToolBar.setItems([doneButton], animated: true)
        self.view.addSubview(datePickerToolBar)
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
        self.dateLabel.text = dateString

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        weatherPicker.delegate = self
        weatherPicker.dataSource = self
    }
    
    // MARK: - Weather picker methods
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weatherPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weatherPickerData[row]
    }

    // MARK: - Search bar methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){

        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }

            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
}

