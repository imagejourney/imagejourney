import Parse
import UIKit
import Material
import SwiftSpinner

class SignInViewController: UIViewController, TextFieldDelegate {
    @IBOutlet var loginBtn: RaisedButton!
    var passwordField: TextField!
    var emailField: TextField!
    
    @IBAction func onSignIn(_ sender: UIButton) {
        let username = emailField.text!
        let password = passwordField.text!
        SwiftSpinner.show(Constants.LOGIN_LOADING_MSG)
        ParseClient.sharedInstance.userSignIn(username: username, password: password, onSuccess: {
            (user: PFUser?) -> () in
            User.setCurrentUser(user: user!)
            self.clearText()
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            SwiftSpinner.hide()
        }, onError: {(error: Error? ) in
            self.showErrorAlert(errorMsg: (error?.localizedDescription)!)
            SwiftSpinner.hide()
        })
    }
    
    @IBAction func onSignUpClick(_ sender: FlatButton) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let signupController = storyBoard.instantiateViewController(withIdentifier: "SignUpView") as! SignUpViewController
        self.present(signupController, animated: true, completion: nil)
    }
    
    // disable default segue animation, only perform segue once authentication passes
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparePasswordField()
        prepareEmailField()
    }
    
    func clearText(){
        self.emailField.text = ""
        self.passwordField.text = ""
        self.emailField.becomeFirstResponder()
    }
    
    func showErrorAlert(errorMsg: String) {
        let alertController = UIAlertController(title: "Login Failure", message: errorMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.clearText()
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
}

extension SignInViewController {
    fileprivate func prepareEmailField() {
        emailField = TextField()
        emailField.placeholder = "Enter your username here."
        emailField.autocapitalizationType = .none
        emailField.isClearIconButtonEnabled = true
        emailField.delegate = self
        
        let leftView = UIImageView()
        leftView.image = UIImage(named: "email")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        leftView.tintColor = Constants.THEME_COLOR
        emailField.leftView = leftView
        
        view.layout(emailField).center(offsetY: -passwordField.height - Constants.LOGIN_EMAIL_FIELD_OFFSET).left(Constants.LOGIN_FIELD_MARGIN).right(Constants.LOGIN_FIELD_MARGIN)
        emailField.becomeFirstResponder()
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Enter your password here."
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        
        let leftView = UIImageView()
        leftView.image = UIImage(named: "lock")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        leftView.tintColor = Constants.THEME_COLOR
        passwordField.leftView = leftView
        
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        
        view.layout(passwordField).center(offsetY: Constants.LOGIN_EMAIL_FIELD_OFFSET).left(Constants.LOGIN_FIELD_MARGIN).right(Constants.LOGIN_FIELD_MARGIN)
    }
}
