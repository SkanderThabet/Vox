//
//  WelcomeViewController.swift
//  Vox
//
//  Created by Skander Thabet on 7/4/2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var googleAuth: UIButton!
    @IBOutlet weak var appleAuth: UIButton!
    @IBOutlet weak var signINAuth: UIButton!
    @IBOutlet weak var signUP: UIButton!
    
    // MARK: - Actions
    @IBAction func googleAuthBtn(_ sender: Any) {
    }
    @IBAction func appleAuthBtn(_ sender: Any) {
    }
    @IBAction func signInAuthBtn(_ sender: Any) {
    }
    @IBAction func signUpBtn(_ sender: Any) {
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
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

extension WelcomeViewController {
    static func sharedInstance() -> WelcomeViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
    }
}

