//
//  SideMenuViewController.swift
//  imagejourney
//
//  Created by James Man on 5/7/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import UIKit
import Parse
class SideMenuViewController: UIViewController {
    var currentView:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSignOut(_ sender: Any) {
        User.logout()
        PFUser.logOut()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onHomefeedViewNav(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeFeedCtrl = storyBoard.instantiateViewController(withIdentifier: "HomefeedNavigationCtl") as! UINavigationController
        self.present(homeFeedCtrl, animated: true, completion: nil)
    }
    
    @IBAction func onProfileViewNav(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let profileCtrl = storyBoard.instantiateViewController(withIdentifier: "ProfileNavigationCtl") as! UINavigationController
        self.present(profileCtrl, animated: true, completion: nil)
        
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
