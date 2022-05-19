//
//  MenuController.swift
//  Vox
//
//  Created by Skander Thabet on 2/5/2022.
//

import UIKit
import SwiftUI
import StreamChat
import StreamChatUI


struct MenuItem {
    let icon : UIImage
    let title: String
}

class MenuController: UITableViewController {
    
    let menuItems = [
        MenuItem(icon: UIImage(systemName: "house.fill")!, title: "Home"),
        MenuItem(icon: UIImage(systemName: "person.fill")!, title: "Profile"),
        MenuItem(icon: UIImage(named: "Chat messaging-1")!, title: "Messages"),
        MenuItem(icon: UIImage(named: "Podcast")!, title: "Podcast"),
        MenuItem(icon: UIImage(systemName: "gear")!, title: "Settings")
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
    }
    
    //MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeader = CustomHeaderMenu()
        return customHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuItemCell(style: .default, reuseIdentifier: "cellId")
        let menuItem = menuItems[indexPath.row]
        cell.titleLabel.text = menuItem.title
        cell.iconImageView.image = menuItem.icon
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            handleHVC()
            
        case 1:
            handlePVC()
        case 2:
            print("Chat")
            let user = UserDefaults.standard.callingUser(forKey: "user")
            
            let config = ChatClientConfig(apiKey: APIKey("uwx2yzzbyqaf"))
            let client = ChatClient(config: config)
            
            client.connectUser(
                userInfo: UserInfo(id: user?.user.username ?? ""),
                token: .development(userId: "\(user?.user.username ?? "")")
            )
            
            let channelList = iMessageChatChannelListViewController()
//            let query = ChannelListQuery(filter: .containMembers(userIds: [userId]))
//            channelList.controller = ChatClient.shared.channelListController(query: query)
//            let ChatVC = iMessageChatChannelListViewController.sharedInstance()
            
            self.navigationController?.pushViewController(channelList, animated: true)
        case 3:
            let podcast = MainTabBarViewController.sharedInstance()
            self.navigationController?.pushViewController(podcast, animated: true)
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        case 4:
            let settings = SettingsViewController.sharedInstance()
            self.navigationController?.pushViewController(settings, animated: true)
        default:
            print("show w barra")
        }
    }
    
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
    fileprivate func handleHVC() {
        
        let user = UserDefaults.standard.callingUser(forKey: "user")
        let userCall = (user!).user
        let firstname = userCall.firstname
        let homeVC = HomeViewController.sharedInstance()
        let hour = Calendar.current.component( .hour, from:Date() ) > 11 ? "Good Evening" : "Good Morning"
        homeVC.greetinLabel = "\(hour),\n\(firstname)"
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
}



//MARK: - Extensions

//extension MenuController {
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        let story = UIStoryboard(name: "Main", bundle:nil)
////        let vc = story.instantiateViewController(withIdentifier: "BaseSlidingController") as! BaseSlidingController
////        UIApplication.shared.windows.first?.rootViewController = vc
////        vc.didSelectItemMenu(indexPath: indexPath)
////        UIApplication.shared.windows.first?.makeKeyAndVisible()
//
//
//        let baseSlidingController = UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController
//        baseSlidingController?.didSelectItemMenu(indexPath: indexPath)
//
//    }
//}
