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
    
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var journalIcon: UIImageView!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var searchIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentState = Constants.MENU_STATE.home_feed.rawValue
        self.homeIcon.tintColor = Constants.THEME_COLOR
    }
    
    override func viewDidAppear(_ animated: Bool) {
        user = User.getCurrentUser()
        setupProfile()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchActiveIconColor(icon: String) {
        self.homeIcon.tintColor = Constants.LIGHT_GRAY
        self.journalIcon.tintColor = Constants.LIGHT_GRAY
        self.profileIcon.tintColor = Constants.LIGHT_GRAY
        self.searchIcon.tintColor = Constants.LIGHT_GRAY
        
        switch icon {
            case "home":
                self.homeIcon.tintColor = Constants.THEME_COLOR
            case "journal":
                self.journalIcon.tintColor = Constants.THEME_COLOR
            case "profile":
                self.profileIcon.tintColor = Constants.THEME_COLOR
            default:
                self.searchIcon.tintColor = Constants.THEME_COLOR
        }
    }
    
    func setupProfile(){
        curUserImageView.layer.cornerRadius = curUserImageView.frame.size.width/2
        curUserImageView.clipsToBounds = true
        if user?.profileImageUrl != nil {
            curUserImageView.setImageWith((user?.profileImageUrl!)!)
        } else {
            curUserImageView.image = UIImage(named: "avatar-\(arc4random_uniform(6) + 1)")
        }
        curUserNameLabel.text = user?.name ?? "Anonymous"
        curUserUsernameLabel.text = "@\(String(describing: (user?.username)!))"
        
        let border = CALayer()
        border.frame = CGRect(x:0, y:profileViewContainer.frame.height - 1, width:profileViewContainer.frame.width, height: 1)
        border.backgroundColor = Constants.LIGHT_GRAY.cgColor
        profileViewContainer.layer.addSublayer(border)
    }
    
    @IBAction func onSignOut(_ sender: Any) {
        User.logout()
        PFUser.logOut()
        Helper.dismissSideMenu()
        let signInUpNav = self.storyboard?.instantiateViewController(withIdentifier: "SignInUpNav")
        UIApplication.shared.keyWindow?.rootViewController = signInUpNav
    }
    
    @IBAction func onSearchNav(_ sender: Any) {
        if currentState != Constants.MENU_STATE.search.rawValue{
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let searchCtrl = storyBoard.instantiateViewController(withIdentifier: "SearchNavigationCtl") as! UINavigationController
            self.present(searchCtrl, animated: true, completion: nil)
            currentState = Constants.MENU_STATE.search.rawValue
            self.switchActiveIconColor(icon: "search")
        } else {
            Helper.dismissSideMenu()
        }
    }
    
    @IBAction func onHomefeedViewNav(_ sender: Any) {
        if currentState != Constants.MENU_STATE.home_feed.rawValue {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeFeedCtrl = storyBoard.instantiateViewController(withIdentifier: "HomefeedNavigationCtl") as! UINavigationController
            self.present(homeFeedCtrl, animated: true, completion: nil)
            currentState = Constants.MENU_STATE.home_feed.rawValue
            self.switchActiveIconColor(icon: "home")
        } else {
            Helper.dismissSideMenu()
        }
    }
    
    @IBAction func onRecentJournalNav(_ sender: Any) {
        if currentState != Constants.MENU_STATE.most_recent_journal.rawValue {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let journalVC = storyBoard.instantiateViewController(withIdentifier: "JournalViewController") as! JournalViewController
            ParseClient.sharedInstance.getCurrentUserMostRecentJournal(completion: { (journal) in
                journalVC.journal = journal
                self.show(journalVC, sender: nil)
            })
            self.switchActiveIconColor(icon: "journal")
        } else {
            Helper.dismissSideMenu()
        }
    }
    
    @IBAction func onProfileViewNav(_ sender: Any) {
        if currentState != Constants.MENU_STATE.profile.rawValue {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let profileCtrl = storyBoard.instantiateViewController(withIdentifier: "ProfileNavigationCtl") as! UINavigationController
            self.present(profileCtrl, animated: true, completion: nil)
            currentState = Constants.MENU_STATE.profile.rawValue
            self.switchActiveIconColor(icon: "profile")
        } else {
            Helper.dismissSideMenu()
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
