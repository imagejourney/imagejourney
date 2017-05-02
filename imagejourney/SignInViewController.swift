import Parse
import UIKit
import Material

class SignInViewController: UIViewController, TextFieldDelegate {
    @IBOutlet var loginBtn: RaisedButton!
    var passwordField: TextField!
    var emailField: TextField!
    
    let MARGIN:CGFloat = 20
    let EMAIL_FIELD_OFFSET:CGFloat = 50
    
    @IBAction func onSignIn(_ sender: UIButton) {
        let username = emailField.text!
        let password = passwordField.text!
        toggleLoginBtn(isLoggingIn: true)
        ParseClient.sharedInstance.userSignIn(username: username, password: password, onSuccess: {
            () in
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            self.toggleLoginBtn(isLoggingIn: false)
        }, onError: {(error: Error? ) in
            self.showErrorAlert(errorMsg: (error?.localizedDescription)!)
            self.toggleLoginBtn(isLoggingIn: false)
        })
    }
    
    func toggleLoginBtn(isLoggingIn:Bool){
        if isLoggingIn {
            self.loginBtn.isEnabled = false
            self.loginBtn.isUserInteractionEnabled = false
            self.loginBtn.title = "Logging In..."
        } else {
            self.loginBtn.isEnabled = true
            self.loginBtn.isUserInteractionEnabled = true
            self.loginBtn.title = "Log In"
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparePasswordField()
        prepareEmailField()
    }
    
    
    func showErrorAlert(errorMsg: String) {
        let alertController = UIAlertController(title: "Login Failure", message: errorMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.emailField.text = ""
            self.passwordField.text = ""
            self.emailField.becomeFirstResponder()
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
        leftView.image = UIImage(named: "email")
        emailField.leftView = leftView
        
        view.layout(emailField).center(offsetY: -passwordField.height - EMAIL_FIELD_OFFSET).left(MARGIN).right(MARGIN)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Enter your password here."
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        
        let leftView = UIImageView()
        leftView.image = UIImage(named: "lock")
        passwordField.leftView = leftView
        
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        
        view.layout(passwordField).center().left(MARGIN).right(MARGIN)
    }
}
