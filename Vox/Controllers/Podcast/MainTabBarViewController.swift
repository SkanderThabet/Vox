//
//  MainTabBarViewController.swift
//  Vox
//
//  Created by Skander Thabet on 15/4/2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        // Do any additional setup after loading the view.
        setupViewControllers()
        setupPlayerDetailsView()
    }
    
    @objc func minimizePlayerDetails()  {
        print(111)
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = false
            self.tabBar.transform = .identity
            self.playerDetailsView.maximizedStackPlayerView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
        })

    }
    
    func maximizePlayerDetails(episode: Episode?) {
        print(222)
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        
        bottomAnchorConstraint.constant = 0
        if (episode != nil) {
            playerDetailsView.episode = episode
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.tabBar.isHidden = true
            self.playerDetailsView.maximizedStackPlayerView.alpha = 1
            self.playerDetailsView.miniPlayerView.alpha = 0
        })
    }
    
    // MARK: - Setup Functions
    let playerDetailsView = PlayerDetailsView.initFromNib()
    var maximizedTopAnchorConstraint : NSLayoutConstraint!
    var minimizedTopAnchorConstraint : NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    func setupPlayerDetailsView() {
        print("Setting up PlayerDetailsView")
        
        
        
        //use auto layout
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        //enable auto layout
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let favoritesController = FavoritesController(collectionViewLayout: layout)

        viewControllers = [
            generateNavigationController(for: PodcastSearchController(), title: "Search", image: UIImage(named: "search")!),
            generateNavigationController(for: favoritesController, title: "Favorites", image: UIImage(named: "favorites")!),
            generateNavigationController(for: ViewController(), title: "Download", image: UIImage(named: "downloads")!)
        
        ]
    }
    
    // MARK: - Helper Function
    
    fileprivate func generateNavigationController(for rootViewController : UIViewController, title : String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
//        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
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
