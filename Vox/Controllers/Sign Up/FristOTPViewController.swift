//
//  FristOTPViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit
import CountryPickerView
import FirebaseAuth

class FristOTPViewController: UIViewController {
    

    
    
    // MARK: - Outlets
    @IBOutlet weak var mobileNumberTF: UITextField!
    weak var cpvTextField: CountryPickerView!
    
    // MARK: - Actions
    @IBAction func getOtpBtn(_ sender: Any) {
        checkNumber()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GetOTP" {
            let countryCode = cpvTextField.selectedCountry.phoneCode
            let phoneNumber = "\(countryCode as String)\(mobileNumberTF.text! as String)"
            guard let secondOTP = segue.destination as? SecondOTPViewController else {
                return
        }
            secondOTP.textValue = phoneNumber
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPickerInit()
        
        // Do any additional setup after loading the view.
    }
    
    func countryPickerInit(){
        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        let country = cpv.selectedCountry
        
        mobileNumberTF.leftView = cpv
        mobileNumberTF.leftViewMode = .always
        self.cpvTextField = cpv
        cpvTextField.dataSource = self
        cpvTextField.delegate = self
        print(country.phoneCode)
        
        mobileNumberTF.showDoneButtonOnKeyboard()
    }
    
    private func checkNumber() {
        let countryCode = cpvTextField.selectedCountry.phoneCode
        let phoneNumber = "\(countryCode)\(mobileNumberTF.text! as String)"
        let alert = UIAlertController(title: "Verification", message: "We will be verifying the phone number : \(phoneNumber)\n" + "Is this OK, or would you like to edit the number ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.performSegue(withIdentifier: "GetOTP", sender: self)
        }))
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
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}

extension FristOTPViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        showAlert(title: title, message: message)
    }
}

extension FristOTPViewController: CountryPickerViewDataSource {
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
}
extension UITextField {
    func showDoneButtonOnKeyboard() {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
        
        var toolBarItems = [UIBarButtonItem]()
        toolBarItems.append(flexSpace)
        toolBarItems.append(doneButton)
        
        let doneToolbar = UIToolbar()
        doneToolbar.items = toolBarItems
        doneToolbar.sizeToFit()
        
        inputAccessoryView = doneToolbar
    }
}
