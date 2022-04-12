//
//  SecondOTPViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit

class SecondOTPViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var numberRecieverLabel: UILabel!
    
    @IBOutlet weak var firstDigitTF: UITextField!
    @IBOutlet weak var secondDigitTF: UITextField!
    @IBOutlet weak var thirdDigitTF: UITextField!
    @IBOutlet weak var fourthDigitTF: UITextField!
    @IBOutlet weak var fifthDigitTF: UITextField!
    @IBOutlet weak var sixthDigitTF: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    
    
    // MARK: - Actions
    @IBAction func verifyBtn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
