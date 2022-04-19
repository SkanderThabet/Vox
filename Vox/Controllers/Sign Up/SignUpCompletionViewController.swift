//
//  SignUpCompletionViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit
import JGProgressHUD
import Alamofire
import FirebaseStorage
import FirebaseAuth
import Firebase
import Photos


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
    
    
    var fUID: String = ""
    let dataPicker = UIDatePicker()
    lazy var storage = Storage.storage()
    lazy var auth = Auth.auth()
    var downloadURL:URL?
    // MARK: - Actions
    @IBAction func completeBtn(_ sender: Any) {
        handleSignUp()
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        //we want this Controller to be delegate
        imagePicker.delegate = self
        imagePicker.sourceType =
        UIImagePickerController.isSourceTypeAvailable(.camera)
        ? .camera
        : .photoLibrary
        imagePicker.allowsEditing = true
         present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = "Something went wrong during sign up, please try again"
        errorLabel.isHidden = true
        emailTF.autocapitalizationType = .none
        createDatePicker()
        
        checkPermissions()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Permission Check Function
    
    func checkPermissions() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    // MARK: - Request Handler for permission
    func requestAuthorizationHandler(status : PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("'We have access to photos'")
        }
        else {
            print("We don't have access to photos")
        }
    }
    
    //MARK: - Upload to firebase
    
    func uploadToCloud(fileUrl : URL) {
        let data = Data()
        let storageRef = storage.reference()
        let localFile = fileUrl
        let photoRef = storageRef.child("uploads/"+auth.currentUser!.uid)
        let uploadTaks = photoRef.putFile(from: localFile, metadata: nil) { (metadata,err) in
            guard let metadata = metadata else {
                self.displayError(err)
                print(err?.localizedDescription)
                return
            }
            photoRef.downloadURL { url, err in
                if let url = url {
                    self.downloadURL = url
                    print(self.downloadURL)
                                }
            }
            print("'Photo uploaded'")
        }
        
    }
    
//    func pullImage() {
//        let storageRef = storage.reference()
//        let photoRef = storageRef.child("uploads/"+auth.currentUser!.uid)
//        downloadURL = avatarImage.sd
//        print(downloadURL)
//    }
    
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
    
    // MARK: - Done Button when editing
    
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
        let params = ["firstname":firstname , "lastname":lastname , "email":email , "password":password , "dob":dob , "avatar":self.downloadURL?.absoluteString]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding())
            .validate(statusCode: 200..<300)
            .responseData{ (dataResp) in
                hud.dismiss()
                if let err = dataResp.error {
                    print("Failed to sign up : ", err)
                    self.errorLabel.isHidden = false
                    self.displayError(err)
                    return
                }
                print("Successfully signed up")
                self.showAlert(title: "Sign up", message: "Successfully registered ! ")
            }
    }
    
    // MARK: - Show Alert Function
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}

extension SignUpCompletionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            print(url)
            uploadToCloud(fileUrl: url)
        }
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        avatarImage.image = selectedImage
        dismiss(animated: true)
    }
}
