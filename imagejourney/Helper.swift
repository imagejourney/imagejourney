//
//  Helper.swift
//  imagejourney
//
//  Created by James Man on 5/7/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit
import SidebarOverlay
import Photos
import Parse

class Helper {
    static var sideMenuController: UIViewController? = nil
    static  func UIColorFromHex(rgbValue:UInt, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    static func dismissSideMenu(){
        let root = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let visibile = root?.visibleViewController as? SOContainerViewController
        visibile?.isSideViewControllerPresented = !(visibile?.isSideViewControllerPresented)!
    }
    
    static func getMenuController() -> UIViewController{
        if self.sideMenuController == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.sideMenuController = storyboard.instantiateViewController(withIdentifier: "sidemenu") as? SideMenuViewController
        }
        return self.sideMenuController!
    }
    
    static func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    static func getLocationString(location: PFGeoPoint, handler: @escaping ((String) -> Void)) -> Void {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (location.latitude), longitude: (location.longitude))
        var locationString = "Unknown Location"
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            if placemarks != nil {
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // Location name
                if let locationName = placeMark.addressDictionary!["Name"] as? String {
                    locationString = locationName
                    if let state = placeMark.addressDictionary!["State"] as? String {
                        locationString = "\(locationName), \(state)"
                    } else if let country = placeMark.addressDictionary!["Country"] as? String {
                        locationString = "\(locationName), \(country)"
                    }
                }
                handler(locationString)
            }
        })
    }
    
    static func getMapSegmentColors(color1: UIColor, color2: UIColor, segmentIndex: Int, totalSegments:Int) -> (segmentedColor1: UIColor, segmentedColor2: UIColor) {
        let colorComponents1 = color1.cgColor.components
        let colorComponents2 = color2.cgColor.components
        
        let ratio1a = CGFloat(totalSegments - segmentIndex) / CGFloat(totalSegments)
        let ratio2a = CGFloat(segmentIndex) / CGFloat(totalSegments)
        
        let ratio1b = CGFloat(totalSegments - (segmentIndex + 1)) / CGFloat(totalSegments)
        let ratio2b = CGFloat(segmentIndex + 1) / CGFloat(totalSegments)
        
        let colora = UIColor(red: (colorComponents1?[0])! * ratio1a + (colorComponents2?[0])! * ratio2a, green: (colorComponents1?[1])! * ratio1a + (colorComponents2?[1])! * ratio2a, blue: (colorComponents1?[2])! * ratio1a + (colorComponents2?[2])! * ratio2a, alpha: (colorComponents1?[3])! * ratio1a + (colorComponents2?[3])! * ratio2a)
        
        let colorb = UIColor(red: (colorComponents1?[0])! * ratio1b + (colorComponents2?[0])! * ratio2b, green: (colorComponents1?[1])! * ratio1b + (colorComponents2?[1])! * ratio2b, blue: (colorComponents1?[2])! * ratio1b + (colorComponents2?[2])! * ratio2b, alpha: (colorComponents1?[3])! * ratio1b + (colorComponents2?[3])! * ratio2b)
        
        return (colora, colorb)
    }
}

// http://stackoverflow.com/a/39480016/1272813
extension UIImage {
    func addImagePadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let width: CGFloat = self.size.width + x
        let height: CGFloat = self.size.width + y
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - self.size.width) / 2, y: (height - self.size.height) / 2)
        self.draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithPadding
    }
}
