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
        perform(#selector(maximizePlayerDetails), with: nil, afterDelay: 1)
    }
    
    @objc func minimizePlayerDetails()  {
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }

    }
    
    @objc func maximizePlayerDetails() {
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        minimizedTopAnchorConstraint.isActive = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Setup Functions
    var maximizedTopAnchorConstraint : NSLayoutConstraint!
    var minimizedTopAnchorConstraint : NSLayoutConstraint!
    
    fileprivate func setupPlayerDetailsView() {
        print("Setting up PlayerDetailsView")
        let playerDetailsView = PlayerDetailsView.initFromNib()
        playerDetailsView.backgroundColor = .red
        
        //use auto layout
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        //enable auto layout
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    func setupViewControllers() {
        viewControllers = [
            generateNavigationController(for: PodcastSearchController(), title: "Search", image: UIImage(named: "search")!),
            generateNavigationController(for: ViewController(), title: "Favorites", image: UIImage(named: "favorites")!),
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
