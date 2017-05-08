//
//  Helper.swift
//  imagejourney
//
//  Created by James Man on 5/7/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit
import SidebarOverlay

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
}

