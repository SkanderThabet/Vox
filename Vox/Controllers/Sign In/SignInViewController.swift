//
//  SignInViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit
import JGProgressHUD
import Alamofire

class SignInViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotPwd: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    // MARK: - Actions
    @IBAction func signInBtn(_ sender: Any) {
        handleLogin()
    }
    
    // MARK: - Handle Login Function
    @objc func handleLogin(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Logging in"
        hud.show(in: view)
        
        guard let email = emailTF.text else { return }
        guard let password = passwordTF.text else { return }
        errorLabel.isHidden = true
        
        let url = "https://voxappli.herokuapp.com/api/vox/auth/login"
        let params = ["email" : email,"password" : password]
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding())
            .validate(statusCode: 200..<300)
            .responseData { (DataResponse)  in
                
                hud.dismiss()
                if let _ = DataResponse.error {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Your credentials are not correct, please try again"
                    print(DataResponse.error as Any)
                    return
                }
                
                self.showAlert(title: "Loggin", message: "Successfully logged in")
                
                
            }
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
