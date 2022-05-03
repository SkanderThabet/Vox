//
//  MainMenuTableViewController.swift
//  Vox
//
//  Created by Skander Thabet on 30/4/2022.
//

import UIKit

class MainMenuTableViewController: UITableViewController {

    // MARK: - Constants & Variables
    fileprivate let menuController = MenuController()
    fileprivate let menuWidth : CGFloat = 300
    fileprivate var isMenuOpened = false
    fileprivate let velocityOpenThresholder: CGFloat = 500
    let darkCoverView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItem()
        initMenuPosition()
        setupPanGesture()
        setupDarkCoverView()
    }
    
    
    //MARK: - Setup Functions
    
    fileprivate func setupDarkCoverView() {
        darkCoverView.alpha = 0
        darkCoverView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        darkCoverView.isUserInteractionEnabled = false
        navigationController?.view.addSubview(darkCoverView)
        darkCoverView.frame = view.frame
        
        /** in case there's problem with previous ios phones here a fix for dark cover view
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(darkCoverView)
        darkCoverView.frame = mainWindow?.frame ?? .zero
         */
        
    }
    
    fileprivate func setupPanGesture() {
        //Pan Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }
    
    fileprivate func setupNavItem() {
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(handleOpen))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(handleHide))
    }
    
    fileprivate func initMenuPosition() {
        menuController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth , height: self.view.frame.height)
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(menuController.view)
        addChild(menuController)
    }
    
    //MARK: - Perform Actions Function
    fileprivate func performAnimations(transform : CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            
            //final position to animate our menuController object
            self.menuController.view.transform = transform
            self.navigationController?.view.transform = transform
            self.darkCoverView.alpha = transform == .identity ? 0 : 1
        }
    }
    //MARK: - Handle Functions
    @objc func handleOpen() {
        isMenuOpened = true
        print("Open menu")
        performAnimations(transform: CGAffineTransform(translationX: self.menuWidth, y: 0))
    }
    
    @objc func handleHide() {
        isMenuOpened = false
        print("Hide menu")
        performAnimations(transform: .identity)
        
    }

    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        if isMenuOpened {
            if abs(velocity.x) > velocityOpenThresholder {
                handleHide()
                return
            }
            if abs(translation.x) < menuWidth / 2 {
                handleOpen()
            } else {
                handleHide()
            }
        } else {
            if velocity.x > velocityOpenThresholder {
                handleOpen()
                return
            }
            if translation.x < menuWidth / 2 {
                handleHide()
            } else {
                handleOpen()
            }
        }
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        var x: CGFloat = translation.x
        if gesture.state == .changed {
            if isMenuOpened {
                x += menuWidth
            }
            x = min(menuWidth, x)
            x = max(0, x)
            let transofrm = CGAffineTransform(translationX: x, y: 0)
            menuController.view.transform = transofrm
            navigationController?.view.transform = transofrm
            darkCoverView.alpha = x / menuWidth
        } else if gesture.state == .ended {
            handleEnded(gesture : gesture)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        var content = cell.defaultContentConfiguration()
        content.text = "Row : \(indexPath.row)"
        cell.contentConfiguration = content
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
