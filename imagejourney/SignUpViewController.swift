//
//  SignUpViewController.swift
//  imagejourney
//
//  Created by James Man on 4/30/17.
//  Copyright © 2017 Codepath. All rights reserved.
//

import Parse
import UIKit
import Material
import SwiftSpinner

class SignUpViewController: UIViewController, TextFieldDelegate {
    @IBOutlet var signUpBtn: RaisedButton!
    var nameField: TextField!
    var usernameField: TextField!
    var passwordField: TextField!
    var passwordCheckField: ErrorTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparePasswordField()
        prepareNameField()
        prepareEmailField()
    }
    
    @IBAction func onLoginTap(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let signInCtl = storyBoard.instantiateViewController(withIdentifier: "SignInView") as! SignInViewController
        self.present(signInCtl, animated: true, completion: nil)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        let name = nameField.text!
        
        // name is required
        if name == "" {
            self.showErrorAlert(errorMsg: Constants.EMPTY_NAME_ERROR_MSG)
            return
        }
        
        SwiftSpinner.show(Constants.SIGN_UP_LOADING_MSG)
        ParseClient.sharedInstance.userSignUp(name: name, username: username, password: password, onSuccess: {
            (user: PFUser?) -> () in
            User.setCurrentUser(user: user!)
            self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            SwiftSpinner.hide()
        }, onError: {(error: Error? ) in
            self.showErrorAlert(errorMsg: (error?.localizedDescription)!)
            SwiftSpinner.hide()
        })
    }
    
    // disable default segue animation, only perform segue once authentication passes
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    func showErrorAlert(errorMsg: String) {
        let alertController = UIAlertController(title: "Sign Up Failure", message: errorMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.usernameField.text = ""
            self.nameField.text = ""
            self.passwordField.text = ""
            self.passwordCheckField.text = ""
            self.nameField.becomeFirstResponder()
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
    
    func textFieldDidChange(sender: ErrorTextField){
        let pwdFieldTxt = self.passwordField.text!
        let pwdCheckFieldTxt = self.passwordCheckField.text!
        if (!pwdFieldTxt.isEmpty && pwdFieldTxt != pwdCheckFieldTxt) {
            self.passwordCheckField.isErrorRevealed = true
            self.passwordCheckField.detailLabel.text = Constants.PASSWORD_NOT_MATCH_MSG
        } else {
            self.passwordCheckField.isErrorRevealed = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SignUpViewController {
    fileprivate func prepareNameField() {
        nameField = TextField()
        nameField.placeholder = "Enter your name here."
        nameField.autocapitalizationType = .words
        nameField.isClearIconButtonEnabled = true
        nameField.delegate = self
        
        let leftView = UIImageView()
        leftView.image = UIImage(named: "account")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        leftView.tintColor = Constants.THEME_COLOR
        nameField.leftView = leftView
        
        view.layout(nameField).center(offsetY: -passwordField.height - 4 * Constants.SIGNUP_FIELD_OFFSET).left(Constants.SIGNUP_MARGIN).right(Constants.SIGNUP_MARGIN)
        nameField.becomeFirstResponder()
    }
    
    fileprivate func prepareEmailField() {
        usernameField = TextField()
        usernameField.placeholder = "Enter your username here."
        usernameField.autocapitalizationType = .none
        usernameField.isClearIconButtonEnabled = true
        usernameField.delegate = self
        
        let leftView = UIImageView()
        leftView.image = UIImage(named: "email")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        leftView.tintColor = Constants.THEME_COLOR
        usernameField.leftView = leftView
        
        view.layout(usernameField).center(offsetY: -passwordField.height - 2 * Constants.SIGNUP_FIELD_OFFSET).left(Constants.SIGNUP_MARGIN).right(Constants.SIGNUP_MARGIN)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Enter your password here."
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        let pwdleftView = UIImageView()
        pwdleftView.image = UIImage(named: "lock")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        pwdleftView.tintColor = Constants.THEME_COLOR
        passwordField.leftView = pwdleftView
        
        passwordCheckField = ErrorTextField()
        passwordCheckField.placeholder = "Please type your password again."
        passwordCheckField.clearButtonMode = .whileEditing
        passwordCheckField.isVisibilityIconButtonEnabled = true
        let pwdCheckleftView = UIImageView()
        pwdCheckleftView.image = UIImage(named: "lock")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        pwdCheckleftView.tintColor = Constants.THEME_COLOR
        passwordCheckField.leftView = pwdCheckleftView
        
        // Use delete won't work here since it's not a regular TextField but a ErrorTextField
        passwordCheckField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange(sender:)), for: UIControlEvents.editingChanged)
        
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        passwordCheckField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        view.layout(passwordField).center(offsetY: -passwordField.height - Constants.SIGNUP_FIELD_OFFSET).left(Constants.SIGNUP_MARGIN).right(Constants.SIGNUP_MARGIN)
        view.layout(passwordCheckField).center(offsetY: passwordField.height).left(Constants.SIGNUP_MARGIN).right(Constants.SIGNUP_MARGIN)
    }
}

