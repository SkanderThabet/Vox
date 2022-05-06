//
//  HomeViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var greetingUserLabel: UILabel!
    @IBOutlet weak var randomChannel: UIImageView!
    
    
    // MARK: - Actions
    @IBOutlet weak var startStreamingBtn: UIButton!
    
    fileprivate func handlePVC() {
        
        let user = UserDefaults.standard.callingUser(forKey: "user")
        let userCall = (user!).user
        let email = userCall.email
        let firstname = userCall.firstname
        let lastname = userCall.lastname
        let avatar = userCall.avatar
        let dob = userCall.dob
        let username = userCall.username
        let fullname = "\(firstname) \(lastname)"
        let profileVC = ProfileViewController.sharedInstance()
        profileVC.email = email
        profileVC.firstName = firstname
        profileVC.lastName = lastname
        profileVC.dob = dob
        profileVC.userName = username
        profileVC.avatar = avatar
        profileVC.fullName = fullname
        profileVC.status = "Online"
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func startStreamingBtnAct(_ sender: Any) {
        handlePVC()
    }
    
    
    
    var greetinLabel : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingUserLabel.text = greetinLabel ?? ""
        self.navigationItem.hidesBackButton = true
        PlayerDetailsView.initFromNib().removeFromSuperview()
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

extension HomeViewController {
    static func sharedInstance() -> HomeViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
    }
}
