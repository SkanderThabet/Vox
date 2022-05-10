//
//  ChatViewController.swift
//  Vox
//
//  Created by Skander Thabet on 30/4/2022.
//

import UIKit
import StreamChatUI
import StreamChat


class ChatViewController: ChatChannelListVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userAvatarView.addTarget(self, action: #selector(handlePVC), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
    }
    
    @objc func handlePVC() {
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
    
    
    
    
    

}
