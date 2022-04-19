//
//  SignUpCompletionViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit
import JGProgressHUD
import Alamofire


class SignUpCompletionViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let dataPicker = UIDatePicker()
    // MARK: - Actions
    @IBAction func completeBtn(_ sender: Any) {
        handleSignUp()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = "Something went wrong during sign up, please try again"
        errorLabel.isHidden = true
        emailTF.autocapitalizationType = .none
        createDatePicker()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Date picker Function
    
    func createDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        dobTF.inputAccessoryView = toolbar
        
        dobTF.inputView = dataPicker
        dataPicker.preferredDatePickerStyle = .wheels
        dataPicker.datePickerMode = .date
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dobTF.text = formatter.string(from: dataPicker.date)
        self.view.endEditing(true)
        
    }
    
    //MARK: - Handle sign up function
    
    @objc fileprivate func handleSignUp() {
        let hud = JGProgressHUD.init(style: .dark)
        hud.textLabel.text = "Registering"
        hud.show(in: view)
        
        guard let email = emailTF.text else { return}
        guard let password = passwordTF.text else { return}
        guard let firstname = firstnameTF.text else { return}
        guard let lastname = lastnameTF.text else { return}
        guard let dob = dobTF.text else { return}
        
        
        let url = "https://voxappli.herokuapp.com/api/vox/auth/register/"
        let params = ["firstname":firstname , "lastname":lastname , "email":email , "password":password , "dob":dob]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding())
            .validate(statusCode: 200..<300)
            .responseData{ (dataResp) in
                hud.dismiss()
                if let err = dataResp.error {
                    print("Failed to sign up : ", err)
                    self.errorLabel.isHidden = false
                    return
                }
                print("Successfully signed up")
                self.showAlert(title: "Sign up", message: "Successfully registered ! ")
            }
    }
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
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
