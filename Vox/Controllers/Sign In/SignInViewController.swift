//
//  SignInViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit
import JGProgressHUD
import Alamofire
import SwiftMessages

class SignInViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotPwd: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    // MARK: - Actions
    @IBAction func signInBtn(_ sender: Any) {
        handleLogin()
    }
    
    @IBAction func forgetPasswordBtn(_ sender: Any) {
       
    }
    
    
    public func handleProfileVC(_ json: (Any?)) {
        let email = (json as! UserProfile).user.email
        print(email)
        let firstname = (json as! UserProfile).user.firstname
        let lastname = (json as! UserProfile).user.lastname
        let avatar = (json as! UserProfile).user.avatar
        let dob = (json as! UserProfile).user.dob
        let username = (json as! UserProfile).user.username
        let fullname = "\(firstname) \(lastname)"
        let profileVC = ProfileViewController.sharedInstance()
        profileVC.email = email
        profileVC.firstName = firstname
        profileVC.lastName = lastname
        profileVC.dob = dob
        profileVC.userName = username
        profileVC.avatar = avatar
        profileVC.fullName = fullname
        profileVC.status = "Online"
//        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    
    fileprivate func handleHomeScreenVC(_ json: (Any?)) {
        let firstname = (json as! UserProfile).user.firstname
        let lastname = (json as! UserProfile).user.lastname
        let avatar = (json as! UserProfile).user.avatar
        let dob = (json as! UserProfile).user.dob
        let username = (json as! UserProfile).user.username
        let fullname = "\(firstname) \(lastname)"
        let homeVC = HomeViewController.sharedInstance()
        let hour = Hour.hour.getPriciseDateTime(firstname: firstname)
        homeVC.greetinLabel = "\(hour)"
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
    fileprivate func showSuccessAlert() {
        let status = MessageView.viewFromNib(layout: .statusLine)
        status.backgroundView.backgroundColor = UIColor.systemGreen
        status.bodyLabel?.textColor = UIColor.white
        status.configureContent(body: "Connected Successfully")
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.prefersStatusBarHidden = true
        statusConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: statusConfig, view: status)
    }
    
    fileprivate func showErrorAlert() {
        let error = MessageView.viewFromNib(layout: .messageView)
        error.configureTheme(.error)
        error.configureContent(title: "Error", body: "Your credentials are not correct, please try again", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Dismiss") { button in
            SwiftMessages.hide()
        }
        var config = SwiftMessages.defaultConfig
        config.dimMode = .gray(interactive: true)
        config.prefersStatusBarHidden = true
        config.presentationContext = .window(windowLevel: .statusBar)
        config.presentationStyle = .top
        config.duration = .forever
        SwiftMessages.show(config: config, view: error)
    }
    
    fileprivate func loginCallingFunction(_ email: String, _ password: String, _ hud: JGProgressHUD) {
        APIService.shared.callingLoginApi(email: email, password: password, hud) { result in
            switch result {
            case .success(let json):
                print(json as AnyObject)
                self.showSuccessAlert()
                self.handleProfileVC(json)
                self.handleHomeScreenVC(json)
                let token = (json as! UserProfile).token
                print(token)
                TokenService.tokenInstance.saveToken(token: token)
                let test = TokenService.tokenInstance.getToken()
                print(test)
                
                
            case .failure(let err):
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Your credentials are not correct, please try again"
                self.showErrorAlert()
//                print("Error nav to profile : ",self.displayError(err))
            }
        }
    }
    
    @objc func handleLogin(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Logging in"
        hud.show(in: view)
        
        guard let email = emailTF.text else { return }
        guard let password = passwordTF.text else { return }
        errorLabel.isHidden = true
        loginCallingFunction(email, password, hud)
        
    }
    
    
    // MARK: - Show alert Function
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.autocapitalizationType = .none
        passwordTF.isSecureTextEntry = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.tabBarItem.isEnabled = false
        self.navigationItem.backBarButtonItem?.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignInViewController {
    static func sharedInstance() -> SignInViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
    }
}

