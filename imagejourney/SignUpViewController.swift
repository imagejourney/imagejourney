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

class SignUpViewController: UIViewController,TextFieldDelegate {
    @IBOutlet var signUpBtn: RaisedButton!
    var usernameField: TextField!
    var passwordField: TextField!
    var passwordCheckField: TextField!
    
    let MARGIN:CGFloat = 20
    let FIELD_OFFSET:CGFloat = 35

    override func viewDidLoad() {
        super.viewDidLoad()
        preparePasswordField()
        prepareEmailField()
    }

    @IBAction func onLoginTap(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let signInCtl = storyBoard.instantiateViewController(withIdentifier: "SignInView") as! SignInViewController
        self.present(signInCtl, animated: true, completion: nil)
    }
    
    func toggleSignUpBtn(isSigningUp:Bool){
        if isSigningUp {
            self.signUpBtn.isEnabled = false
            self.signUpBtn.isUserInteractionEnabled = false
            self.signUpBtn.title = "Signing up..."
        } else {
            self.signUpBtn.isEnabled = true
            self.signUpBtn.isUserInteractionEnabled = true
            self.signUpBtn.title = "Sign Up!"
        }
    }

    @IBAction func onSignUp(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        toggleSignUpBtn(isSigningUp: true)
        ParseClient.sharedInstance.userSignUp(username: username, password: password, onSuccess: {
            () in
            self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            self.toggleSignUpBtn(isSigningUp: false)
        }, onError: {(error: Error? ) in
            self.showErrorAlert(errorMsg: (error?.localizedDescription)!)
            self.toggleSignUpBtn(isSigningUp: false)
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
            self.passwordField.text = ""
            self.passwordCheckField.text = ""
            self.usernameField.becomeFirstResponder()
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SignUpViewController {
    fileprivate func prepareEmailField() {
        usernameField = TextField()
        usernameField.placeholder = "Enter your username here."
        usernameField.autocapitalizationType = .none
        usernameField.isClearIconButtonEnabled = true
        usernameField.delegate = self
        
        let leftView = UIImageView()
        leftView.image = UIImage(named: "email")
        usernameField.leftView = leftView
        
        view.layout(usernameField).center(offsetY: -passwordField.height - FIELD_OFFSET).left(MARGIN).right(MARGIN)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Enter your password here."
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        let pwdleftView = UIImageView()
        pwdleftView.image = UIImage(named: "lock")
        passwordField.leftView = pwdleftView
        
        passwordCheckField = TextField()
        passwordCheckField.placeholder = "Please type your password again."
        passwordCheckField.clearButtonMode = .whileEditing
        passwordCheckField.isVisibilityIconButtonEnabled = true
        let pwdCheckleftView = UIImageView()
        pwdCheckleftView.image = UIImage(named: "lock")
        passwordCheckField.leftView = pwdCheckleftView
        
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        passwordCheckField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        view.layout(passwordField).center().left(MARGIN).right(MARGIN)
        view.layout(passwordCheckField).center(offsetY: passwordField.height + FIELD_OFFSET).left(MARGIN).right(MARGIN)
    }
}
