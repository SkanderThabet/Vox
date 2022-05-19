//
//  AppDelegate.swift
//  Vox
//
//  Created by Skander Thabet on 29/3/2022.
//

import UIKit
import CoreData
import Firebase
import IQKeyboardManagerSwift
import StreamChat
import StreamChatUI
import AVFoundation
import Logboard

fileprivate func LiveStreamChatConfig() -> ChatClient? {
    var components = Components()
    
    components.channelVC = YTLiveChatViewController.self
    components.messageListVC = YTLiveChatMessageListViewController.self
    components.messageComposerVC = YTChatComposerViewController.self
    components.messageComposerView = YTChatMessageComposerView.self
    components.scrollToLatestMessageButton = YTScrollToLatestMessageButton.self
    components.sendButton = YTSendButton.self
    components.inputMessageView = YTInputChatMessageView.self
    
    components.messageLayoutOptionsResolver = YTMessageLayoutOptionsResolver()
    
    Components.default = components
    let user = UserDefaults.standard.callingUser(forKey: "user")
    
    let config = ChatClientConfig(apiKey: APIKey("uwx2yzzbyqaf"))
    
    let client = ChatClient(config: config)
    client.connectUser(
        userInfo: .init(id: user?.user.username ?? ""),
        token: .development(userId: "\(user?.user.username ?? "")")
    )
    return client
}

fileprivate func ChatMessagingConfig() -> ChatClient? {
    let user = UserDefaults.standard.callingUser(forKey: "user")
    
    let config = ChatClientConfig(apiKey: APIKey("uwx2yzzbyqaf"))
    
    // Register custom UI elements
    var appearance = Appearance()
    var components = Components()

    appearance.images.openAttachments = UIImage(systemName: "camera.fill")!
        .withTintColor(.systemBlue)

    components.channelContentView = iMessageChatChannelListItemView.self
    components.channelCellSeparator = iMessageCellSeparatorView.self

    components.channelVC = iMessageChatChannelViewController.self
    components.messageListVC = iMessageChatMessageListViewController.self
    components.channelHeaderView = iMessageChatChannelHeaderView.self
    components.messageComposerVC = iMessageComposerVC.self
    components.messageComposerView = iMessageComposerView.self
    components.messageLayoutOptionsResolver = iMessageChatMessageLayoutOptionsResolver()

    Appearance.default = appearance
    Components.default = components

    let client = ChatClient(config: config)
    
    client.connectUser(
        userInfo: UserInfo(id: user?.user.username ?? ""),
        token: .development(userId: "\(user?.user.username ?? "")")
    )
    return client
}

/**
 Below extension is to instantiate ChatClient as shared global var
 */

extension ChatClient {
    /// The singleton instance of `ChatClient`
    static var shared: ChatClient! = {
        return ChatMessagingConfig()
    }()
        static let sharedLive: ChatClient! = {
            return LiveStreamChatConfig()
    }()
}
/**
 Below property is to log streaming results
 */
let logger = Logboard.with("com.skanderthabetiOS.Vox")

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
//        window = UIWindow()
//        window?.makeKeyAndVisible()
//        window?.rootViewController = YTLiveVideoViewController()
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        window?.rootViewController = UINavigationController(
//            rootViewController: iMessageChatChannelListViewController()
//        )

        let vc : UIViewController?
        if TokenService.tokenInstance.checkForLogin() {
            vc = HomeViewController.sharedInstance()
        }
        else {
            vc = WelcomeViewController.sharedInstance()
        }
        let navVC = UINavigationController(rootViewController: vc!)
        window?.makeKeyAndVisible()
        window?.rootViewController = navVC
        
        /**
         IQ activation
         */
        IQKeyboardManager.shared.enable = true
        
        /**
         Below section is to make sure to setup and activate the AVAudioSession.
         */
        let session = AVAudioSession.sharedInstance()
        do {
            // https://stackoverflow.com/questions/51010390/avaudiosession-setcategory-swift-4-2-ios-12-play-sound-on-silent
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            } else {
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with: [
                    AVAudioSession.CategoryOptions.allowBluetooth,
                    AVAudioSession.CategoryOptions.defaultToSpeaker]
                )
                try session.setMode(.default)
            }
            try session.setActive(true)
        } catch {
            print(error)
            
        }
        /**
         Above section is to make sure to setup and activate the AVAudioSession.
         */
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Vox")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

