//
//  FristOTPViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit
import CountryPickerView

class FristOTPViewController: UIViewController {
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var mobileNumberTF: UITextField!
    weak var cpvTextField: CountryPickerView!
    
    // MARK: - Actions
    @IBAction func getOtpBtn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        let country = cpv.selectedCountry
        
        mobileNumberTF.leftView = cpv
        mobileNumberTF.leftViewMode = .always
        self.cpvTextField = cpv
        cpvTextField.dataSource = self
        cpvTextField.delegate = self
        print(country.phoneCode)
        
        mobileNumberTF.showDoneButtonOnKeyboard()
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
