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
    var currentState:String?
    var user:User?
    @IBOutlet var curUserUsernameLabel: UILabel!
    @IBOutlet var curUserNameLabel: UILabel!
    @IBOutlet var profileViewContainer: UIView!
    @IBOutlet var curUserImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.getCurrentUser()
        setupProfile()
        currentState = Constants.MENU_STATE.home_feed.rawValue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfile(){
        curUserImageView.layer.cornerRadius = curUserImageView.frame.size.width/2
        curUserImageView.clipsToBounds = true
        if user?.profileImageUrl != nil {
            curUserImageView.setImageWith((user?.profileImageUrl!)!)
        } else {
            curUserImageView.image = UIImage(named: "avatar-\(arc4random_uniform(6) + 1)")
        }
        curUserNameLabel.text = user?.name
        curUserUsernameLabel.text = "@\(String(describing: (user?.username)!))"
        
        let border = CALayer()
        border.frame = CGRect(x:0, y:profileViewContainer.frame.height - 1, width:profileViewContainer.frame.width, height: 1)
        border.backgroundColor = Helper.UIColorFromHex(rgbValue: 0x3ec8ef, alpha: 1.0).cgColor
        profileViewContainer.layer.addSublayer(border)
    }
    
    @IBAction func onSignOut(_ sender: Any) {
        User.logout()
        PFUser.logOut()
        let signInUpNav = self.storyboard?.instantiateViewController(withIdentifier: "SignInUpNav")
        UIApplication.shared.keyWindow?.rootViewController = signInUpNav
    }
    
    @IBAction func onSearchNav(_ sender: Any) {
        if currentState != Constants.MENU_STATE.search.rawValue{
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let searchCtrl = storyBoard.instantiateViewController(withIdentifier: "SearchNavigationCtl") as! UINavigationController
            self.present(searchCtrl, animated: true, completion: nil)
            currentState = Constants.MENU_STATE.search.rawValue
        }
    }
    
    @IBAction func onHomefeedViewNav(_ sender: Any) {
        if currentState != Constants.MENU_STATE.home_feed.rawValue {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeFeedCtrl = storyBoard.instantiateViewController(withIdentifier: "HomefeedNavigationCtl") as! UINavigationController
            self.present(homeFeedCtrl, animated: true, completion: nil)
            currentState = Constants.MENU_STATE.home_feed.rawValue
        }
    }
    
    @IBAction func onProfileViewNav(_ sender: Any) {
        if currentState != Constants.MENU_STATE.profile.rawValue {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let profileCtrl = storyBoard.instantiateViewController(withIdentifier: "ProfileNavigationCtl") as! UINavigationController
            self.present(profileCtrl, animated: true, completion: nil)
            currentState = Constants.MENU_STATE.profile.rawValue
        }
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
