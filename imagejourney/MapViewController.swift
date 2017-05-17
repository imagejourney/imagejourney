//
//  MapViewController.swift
//  imagejourney
//
//  Created by James Man on 5/7/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
    var markerList = [GMSMarker]()
    var data = [Dictionary<String, Any>]()
    var journals: [Journal]? = []
    var mapView:GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ***************************************************************************************************
        // Sample data, please follow the structure when passing the data from segue
//        data = [
//            [
//                "longitude" : 37.77,
//                "latitue" : 50.6,
//                "title": "San Francisco",
//                "snippet" : "The city we live in",
//                "image" : ""
//            ],
//            [
//                "longitude" : 121.408,
//                "latitue" : 31.005,
//                "title": "Shanghai",
//                "snippet": "The fastest growing city in the world",
//                "image" : ""
//            ],
//            [
//                "longitude" : 151.20,
//                "latitue" : -30.86,
//                "title": "Sydney",
//                "snippet" : "The opera house",
//                "image" : ""
//            ]
//        ]
        
        // ***************************************************************************************************
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.8683, longitude: 151.2086, zoom: 6)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView?.delegate = self
        view = mapView
        
        if (journals?.isEmpty)! {
            fitAllMarkers()
        } else {
            fitAllMarkersWithJournals()
        }
        self.navigationController?.navigationBar.tintColor = Constants.THEME_COLOR
    }
    
    func fitAllMarkersWithJournals() {
        let path = GMSMutablePath()
        var checkHelper:[String:Bool] = [:]
        for journal in journals! {
            if !(journal.previewImages?.isEmpty)! && journal.latitude != nil && (journal.longitude != nil) {
                let coodinate = CLLocationCoordinate2D(latitude: journal.latitude!, longitude: journal.longitude!)
                let key = "\(journal.latitude!)\(journal.longitude!)"
                if checkHelper[key] != nil {
                    continue
                }else{
                    checkHelper[key] = true
                }
                let marker = GMSMarker()
                marker.position = coodinate
                marker.title = journal.title
                marker.snippet = journal.author?.name
                
                // testing the image view
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                imageView.image = journal.previewImages?[0]
                marker.iconView = imageView
                marker.map = mapView
                marker.userData = journal
                path.add(marker.position)
            }
        }
        
        let bounds = GMSCoordinateBounds(path: path)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        mapView?.animate(with: update)
    }
    
    func fitAllMarkers() {
        let path = GMSMutablePath()
        // Creates a marker in the center of the map.
        
        for item in data {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: item["latitue"] as! CLLocationDegrees, longitude: item["longitude"] as! CLLocationDegrees )
            marker.title = item["title"] as? String
            marker.snippet = item["snippet"] as? String

            // testing the image view
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            if item["image"] != nil || item["image"] != nil {
                imageView.setImageWith(item["image"] as! URL)
            } else {
                imageView.image = UIImage(named: "avatar-\(arc4random_uniform(6) + 1)")
            }
            marker.iconView = imageView
            marker.map = mapView
            path.add(marker.position)
        }
        
        let bounds = GMSCoordinateBounds(path: path)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        mapView?.animate(with: update)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Do the tap even handler here
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let journalViewCtrl = self.storyboard?.instantiateViewController(withIdentifier: "JournalViewController") as? JournalViewController
        journalViewCtrl?.journal = marker.userData as! Journal
        self.navigationController?.pushViewController(journalViewCtrl!, animated: true)
        return true
    }
}
