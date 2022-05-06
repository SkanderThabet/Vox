//
//  BaseSlidingController.swift
//  Vox
//
//  Created by Skander Thabet on 3/5/2022.
//

import UIKit

class BaseSlidingController: UIViewController{
    //MARK: - Constants & Variables
    let redView : UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let blueView : UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let darkCoverView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.7)
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
     let menuWidth : CGFloat = 300
     var isMenuOpened = false
     let velocityThreshold: CGFloat = 500
    var redViewLeadingConstraint: NSLayoutConstraint!
    var rightViewController : UIViewController = UINavigationController(rootViewController: MainMenuTableViewController())
    var redViewTrailingConstraint : NSLayoutConstraint!
    
    fileprivate func navTopBarItemTitleState(title: String) {
        navigationController?.navigationBar.topItem?.title = title
    }
    
    /**
     vidDidLoad
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupViews()
        setupPanGesture()
        navTopBarItemTitleState(title: "Home")
        self.navigationItem.hidesBackButton = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        darkCoverView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapDismiss() {
        closeMenu()
    }
    
    //MARK: - Setup Functions
    fileprivate func setupViews() {
        view.addSubview(redView)
        view.addSubview(blueView)
        
        // Do any additional setup after loading the view.
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: view.topAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            blueView.topAnchor.constraint(equalTo: view.topAnchor),
            blueView.trailingAnchor.constraint(equalTo: redView.leadingAnchor),
            blueView.widthAnchor.constraint(equalToConstant: menuWidth),
            blueView.bottomAnchor.constraint(equalTo: redView.bottomAnchor)
            
            
        ])
        redViewLeadingConstraint = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        redViewLeadingConstraint.isActive = true
        redViewTrailingConstraint = redView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        redViewTrailingConstraint.isActive = true
        setupViewControllers()
        
    }
    
    fileprivate func setupViewControllers() {
//        rightViewController = MainMenuTableViewController()
        let menuController = MenuController()
        let homeView = rightViewController.view!
        let menuView = menuController.view!
        
        homeView.translatesAutoresizingMaskIntoConstraints = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        redView.addSubview(homeView)
        redView.addSubview(darkCoverView)
        blueView.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: redView.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            homeView.bottomAnchor.constraint(equalTo: redView.bottomAnchor),
            homeView.trailingAnchor.constraint(equalTo: redView.trailingAnchor),
            
            menuView.topAnchor.constraint(equalTo: blueView.topAnchor),
            menuView.leadingAnchor.constraint(equalTo: blueView.leadingAnchor),
            menuView.bottomAnchor.constraint(equalTo: blueView.bottomAnchor),
            menuView.trailingAnchor.constraint(equalTo: blueView.trailingAnchor),
            
            darkCoverView.topAnchor.constraint(equalTo: redView.topAnchor),
            darkCoverView.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            darkCoverView.bottomAnchor.constraint(equalTo: redView.bottomAnchor),
            darkCoverView.trailingAnchor.constraint(equalTo: redView.trailingAnchor),
        ])
        addChild(rightViewController)
        addChild(menuController)
    }
    
    fileprivate func setupPanGesture() {
        //Pan Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }
    
    
    //MARK: - Handle Functions
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        if isMenuOpened {
            if abs(velocity.x) > velocityThreshold {
                closeMenu()
                
                return
            }
            if abs(translation.x) < menuWidth / 2 {
                openMenu()
            } else {
                closeMenu()
            }
        } else {
            if abs(velocity.x) > velocityThreshold {
                openMenu()
                return
            }
            
            if translation.x < menuWidth / 2 {
                closeMenu()
            } else {
                openMenu()
            }
        }
    }
    
     func openMenu() {
        isMenuOpened = true
        navTopBarItemTitleState(title: "Menu")
        redViewLeadingConstraint.constant = menuWidth
         redViewTrailingConstraint.constant = menuWidth
        performAnimations()
    }
    
     func closeMenu() {
        redViewLeadingConstraint.constant = 0
         redViewTrailingConstraint.constant = 0
        isMenuOpened = false
        navTopBarItemTitleState(title: "Home")
        performAnimations()
    }
    func didSelectItemMenu(indexPath: IndexPath) {
        performRightViewCleanUp()
        closeMenu()
        switch indexPath.row {
        case 0:
            let homeVC = HomeViewController.sharedInstance()
            rightViewController = homeVC
            let user = UserDefaults.standard.callingUser(forKey: "user")
            let userCall = (user!).user
            let firstname = userCall.firstname
            let hour = Calendar.current.component( .hour, from:Date() ) > 11 ? "Good Evening" : "Good Morning"
            homeVC.greetinLabel = "\(hour),\n\(firstname)"
            
//            let story = UIStoryboard(name: "Main", bundle:nil)
//            let vc = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            UIApplication.shared.windows.first?.rootViewController = vc
////            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        case 1:
            print("Second screen")
        case 2:
            print("Third screen")
            rightViewController = MainTabBarViewController()
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        default:
            print("show w barra")
        }
        redView.addSubview(rightViewController.view)
        addChild(rightViewController)
        redView.bringSubviewToFront(darkCoverView)
        
    }
    fileprivate func performRightViewCleanUp() {
        rightViewController.view.removeFromSuperview()
        rightViewController.removeFromParent()
    }
    
    fileprivate func performAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            // leave a reference link down in desc below
            self.view.layoutIfNeeded()
            self.darkCoverView.alpha = self.isMenuOpened ? 1 : 0
            self.navigationController?.navigationBar.topItem?.title = self.isMenuOpened ? "Menu" : "Home"
        })
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        var x: CGFloat = translation.x
        x = isMenuOpened ? x + menuWidth : x
        x = min(menuWidth, x)
        x = max(0, x)
        
        redViewLeadingConstraint.constant = x
        redViewTrailingConstraint.constant = x
        darkCoverView.alpha = x / menuWidth
        
        if gesture.state == .ended {
            handleEnded(gesture: gesture)
        }
    }
}

extension BaseSlidingController {
    static func sharedInstance() -> BaseSlidingController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "BaseSlidingController") as! BaseSlidingController
        
    }
}
