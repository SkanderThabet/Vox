//
//  SceneDelegate.swift
//  Vox
//
//  Created by Skander Thabet on 29/3/2022.
//

import UIKit
import StreamChat
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let user = UserDefaults.standard.callingUser(forKey: "user")

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        let config = ChatClientConfig(apiKey: .init("uwx2yzzbyqaf"))
//
//            /// user id and token for the user
//        let userId = "\(user?.user.username ?? "")"
//        let token = TokenService.tokenInstance.getToken()
//
//            /// Step 1: create an instance of ChatClient and share it using the singleton
//            ChatClient.shared = ChatClient(config: config)
//
//            /// Step 2: connect to chat
////            ChatClient.shared.connectUser(
////                userInfo: UserInfo(
////                    id: (user?.user.username ?? "")!,
////                    name: "\(user?.user.firstname ?? "") \(user?.user.lastname ?? "")",
////                    imageURL: URL(string: "\(user?.user.avatar ?? "")")
////                ), token: .development(userId: (user?.user.username ?? "")!)
////            )
//        ChatClient.shared.connectUser(
//            userInfo: .init(id: user?.user.username ?? ""),
//            token: .development(userId: "\(user?.user.username ?? "")")
//        )
//            /// Step 3: create the ChannelList view controller
//            let channelList = ChatViewController()
//            let query = ChannelListQuery(filter: .containMembers(userIds: [userId]))
//            channelList.controller = ChatClient.shared.channelListController(query: query)

//            /// Step 4: similar to embedding with a navigation controller using Storyboard
//            window?.rootViewController = UINavigationController(rootViewController: channelList)
        var vc : UIViewController?
        if UserDefaults.standard.hasOnboarded {
            vc = WelcomeViewController.sharedInstance()
            if TokenService.tokenInstance.checkForLogin() {
                        vc = HomeViewController.sharedInstance()
                    }
                    else {
                        vc = WelcomeViewController.sharedInstance()
                    }
        } else {
            vc = OnboardingView.sharedInstance()
        }
//
//        if TokenService.tokenInstance.checkForLogin() {
//            vc = HomeViewController.sharedInstance()
//        }
//        else {
//            vc = WelcomeViewController.sharedInstance()
//        }
        let navVC = UINavigationController(rootViewController: vc!)
        window?.makeKeyAndVisible()
        window?.rootViewController = navVC
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

