//
//  ViewController.swift
//  imagejourney
//
//  Created by Kim Toy (Personal) on 4/23/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit

class ViewController: UIViewController {

    @IBAction func onLogin(_ sender: UIButton) {
        // temp login
        PFUser.logInWithUsername(inBackground: "sophia", password:"sophiaspassword") {
            (user: PFUser?, error: Error?) -> Void in
            if let error = error {
                if let errorMsg = (error as NSError).userInfo["error"] as? String {
                    self.showErrorAlert(errorMsg: errorMsg)
                }
                
            } else {
                // Hooray! Let them use the app now.
                print("logged in")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func showErrorAlert(errorMsg: String) {
        let alertController = UIAlertController(title: "Email Required", message: errorMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
}

