//
//  OnboardingView.swift
//  Vox
//
//  Created by Skander Thabet on 15/5/2022.
//

import UIKit
import paper_onboarding

class OnboardingView: UIViewController {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var getStartedBtn: UIButton!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "Saving 1")!,
                               title: "Broadcast Streaming",
                               description: "Start Live Streaming & Interacting with the Chat",
                           pageIcon: UIImage(),
                           color: UIColor.white,
                               titleColor: UIColor(hexString: "#2D42F3"), descriptionColor: UIColor(hexString: "#722FF5"), titleFont: titleFont, descriptionFont: descriptionFont),
            
            OnboardingItemInfo(informationImage: UIImage(named: "Safety Box 1")!,
                               title: "Chat Messaging",
                               description: "Start chatting with your friends & Make sure to enjoy the GIFS",
                               pageIcon: UIImage(),
                               color: UIColor.white,
                               titleColor: UIColor(hexString: "#2D42F3"), descriptionColor: UIColor(hexString: "#722FF5"), titleFont: titleFont, descriptionFont: descriptionFont),
            
        OnboardingItemInfo(informationImage: UIImage(named: "undraw_podcast_audience_re_4i5q 1")!,
                               title: "Podcast Streaming",
                               description: "Start listening to your favorite Podcasts & Have fun",
                           pageIcon: UIImage(),
                           color: UIColor.white,
                               titleColor: UIColor(hexString: "#2D42F3"), descriptionColor: UIColor(hexString: "#722FF5"), titleFont: titleFont, descriptionFont: descriptionFont),
            
            ]

    override func viewDidLoad() {
      super.viewDidLoad()
        getStartedBtn.isHidden = true

        setupPaperOnboardingView()

        view.bringSubviewToFront(getStartedBtn)
        view.bringSubviewToFront(logoImg)
      }
    

    private func setupPaperOnboardingView() {
            let onboarding = PaperOnboarding()
            onboarding.delegate = self
            onboarding.dataSource = self
            onboarding.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(onboarding)

            // Add constraints
            for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
                let constraint = NSLayoutConstraint(item: onboarding,
                                                    attribute: attribute,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: attribute,
                                                    multiplier: 1,
                                                    constant: 0)
                view.addConstraint(constraint)
            }
        }
    
    
    
    

    }
// MARK: Actions

extension OnboardingView {
    @IBAction func getStartedBtn(_ sender: Any) {
        let welcomeVC = WelcomeViewController.sharedInstance()
        UserDefaults.standard.hasOnboarded = true
        navigationController?.pushViewController(welcomeVC, animated: true)
    }
    
}

//MARK: Constants
private extension OnboardingView {
    
    static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}

// MARK: PaperOnboardingDelegate
extension OnboardingView: PaperOnboardingDelegate {

    func onboardingWillTransitonToIndex(_ index: Int) {
        getStartedBtn.isHidden = index == 2 ? false : true
    }

    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        //item.titleCenterConstraint?.constant = 100
        //item.descriptionCenterConstraint?.constant = 100
        
        // configure item
        
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource
extension OnboardingView: PaperOnboardingDataSource {

    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }

    func onboardingItemsCount() -> Int {
        return 3
    }
    
//        func onboardinPageItemRadius() -> CGFloat {
//            return 2
//        }
    //
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
        func onboardingPageItemColor(at index: Int) -> UIColor {
            return [UIColor(hexString: "#2D42F3"), UIColor(hexString: "#722FF5"),UIColor(hexString: "#00ffff")][index]
        }
}
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension OnboardingView {
    static func sharedInstance() -> OnboardingView {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "OnboardingView") as! OnboardingView
        
    }
}

