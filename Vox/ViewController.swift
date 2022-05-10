//
//  ViewController.swift
//  Vox
//
//  Created by Skander Thabet on 29/3/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        setHomeVC()
        
    }
    fileprivate func setHomeVC() {
        let user = UserDefaults.standard.callingUser(forKey: "user")
        let userCall = (user!).user
        let firstname = userCall.firstname
        let homeVC = HomeViewController.sharedInstance()
        let hour = Calendar.current.component( .hour, from:Date() ) > 11 ? "Good Evening" : "Good Morning"
        homeVC.greetinLabel = "\(hour),\n\(firstname)"
        UIApplication.shared.keyWindow?.viewWithTag(5)?.removeFromSuperview()
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(homeVC, animated: false)
        
        
    }
    
    
}

