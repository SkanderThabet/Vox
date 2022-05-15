//
//  ProfileViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var avatarPlaceHolder: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var stackViewTF: UIStackView!
    
    // MARK: - Actions
    @IBAction func signOutBtn(_ sender: Any) {
        APIService.shared.callingLogOutApi()
    }
    
    var fullName, firstName, lastName , status, userName , email , dob , avatar: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        usernameTF.text = userName
        firstnameTF.text = firstName
        lastnameTF.text = lastName
        dobTF.text = dob
        emailTF.text = email
        guard let url = URL(string: avatar ?? "") else { return }
        avatarPlaceHolder.sd_setImage(with: url)
        avatarPlaceHolder.layer.cornerRadius = 28
        statusLabel.text = status
        fullnameLabel.text = fullName
        
        updateUIView(usernameTF)
        // Do any additional setup after loading the view.
    }
    func updateUIView(_ uiTextField: UITextField) {
        if isEditing {
            return uiTextField.isEnabled = true
        }
        print("update is called")
        if !isEditing {
            uiTextField.resignFirstResponder()      // << here !!
            // uiTextField.endEditing(true)
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
            usernameTF.isEnabled = true
            emailTF.isEnabled = true
            firstnameTF.isEnabled = true
            lastnameTF.isEnabled = true
            dobTF.isEnabled = true
            updateUIView(usernameTF)
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

extension ProfileViewController {
    static func sharedInstance() -> ProfileViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
    }
}
