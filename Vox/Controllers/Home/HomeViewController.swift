//
//  HomeViewController.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import UIKit
import SwiftMessages
class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var greetingUserLabel: UILabel!
    @IBOutlet weak var randomChannel: UIImageView!
    
    
    // MARK: - Actions
    @IBOutlet weak var startStreamingBtn: UIButton!
    
    @IBAction func logOutBarButton(_ sender: Any) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 300)
        messageView.configureTheme(.info)
        messageView.configureContent(title: "Sign out!", body: "Are you sure you want to log out ?", iconImage: UIImage(systemName: "rectangle.portrait.and.arrow.right"), iconText: nil, buttonImage: nil, buttonTitle: "Yes") { _ in
            SwiftMessages.hide()
            APIService.shared.callingLogOutApi()
            self.dismiss(animated: true, completion: nil)
            let homeVC = WelcomeViewController.sharedInstance()
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
        print("Log out clicked")
    }
    private let user = UserDefaults.standard.callingUser(forKey: "user")
    
    fileprivate func handlePVC() {
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
        let liveVC = LiveViewController.sharedInstance()
        self.navigationController?.pushViewController(liveVC, animated: true)
    }
    
    
    
    var greetinLabel : String?
    
    
    fileprivate func randomImageClickerRecognizer() {
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        randomChannel.isUserInteractionEnabled = true
        randomChannel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let getCorrectTime = Hour.hour.getPriciseDateTime(firstname: (user?.user.firstname)!) 
        greetingUserLabel.text = getCorrectTime ?? greetinLabel
        self.navigationItem.hidesBackButton = true
        PlayerDetailsView.initFromNib().removeFromSuperview()
        randomImageClickerRecognizer()
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        // Your action
//        let liveChatChannelVC = YTLiveVideoViewController.sharedInstance()
//        liveChatChannelVC.playPauseButton?.tintColor = UIColor(.white)
        self.navigationController!.pushViewController(YTLiveVideoViewController(nibName: "YTLiveVideoViewController", bundle: nil), animated: true)
//        self.navigationController?.pushViewController(liveChatChannelVC, animated: true)
    }

    
}

extension HomeViewController {
    static func sharedInstance() -> HomeViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
    }
}
