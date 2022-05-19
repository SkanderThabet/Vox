//
//  SecondOTPViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit
import FirebaseAuth
import SwiftMessages
class SecondOTPViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var numberRecieverLabel: UILabel!
    @IBOutlet weak var numberReceiverOTPLabel: UILabel!
    @IBOutlet weak var firstDigitTF: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    var textValue: String = ""
    
    // MARK: - Actions
    @IBAction func verifyBtn(_ sender: Any) {
        signin()
    }
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberReceiverOTPLabel.text = textValue
        phoneAuthLogin()
        firstDigitTF.showDoneButtonOnKeyboard()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OtpToProfileCompletion" {
            
        }
    }
    
    private func phoneAuthLogin() {
        guard let phoneNumber = numberReceiverOTPLabel.text else { return }
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
              if (error == nil) {
                  print(verificationID! as String)
                  guard let verificationID = verificationID else { return }
                  self.userDefault.set(verificationID, forKey: "verificationID")
                  self.userDefault.synchronize()
                  
              }
                  else { return self.showErrorAlert() }

          }
      }
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {

        }
    
    fileprivate func showErrorAlert() {
        let error = MessageView.viewFromNib(layout: .cardView)
        error.configureTheme(.error)
        error.configureContent(title: "Error", body: "Error occured , please try again", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Dismiss") { button in
            SwiftMessages.hide()
        }
        var config = SwiftMessages.defaultConfig
        config.dimMode = .gray(interactive: true)
        config.prefersStatusBarHidden = true
        config.presentationContext = .window(windowLevel: .alert)
        config.presentationStyle = .center
        config.duration = .forever
        SwiftMessages.show(config: config, view: error)
    }
    
    private func signin() {
        guard let otpCode = firstDigitTF.text else { return }
        guard let verificationID = userDefault.string(forKey: "verificationID") else { return }
        let credential = PhoneAuthProvider.provider()
            .credential(withVerificationID: verificationID, verificationCode: otpCode)
        
        Auth.auth().signIn(with: credential) { result, error in
            if (error == nil) {
                
                debugPrint((result?.user.uid)! as String)
                self.performSegue(withIdentifier: "OtpToProfileCompletion", sender: self)
                
//                if(result?.additionalUserInfo?.isNewUser == true) {
//                    self.performSegue(withIdentifier: "OtpToProfileCompletion", sender: self)
//                }
//                else {
//                    self.performSegue(withIdentifier: "unwindToWelcome", sender: self)
//                }
            } else {
                print ("Something went wrong")
//                return self.displayError(error)
                return self.showErrorAlert()
                
            }
     }
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


