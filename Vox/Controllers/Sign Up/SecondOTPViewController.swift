//
//  SecondOTPViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit
import FirebaseAuth

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
                  else { return self.displayError(error) }

          }
      }
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {

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
                return self.displayError(error)
                
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
