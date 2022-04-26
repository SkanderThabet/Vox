//
//  Extension.swift
//  Vox
//
//  Created by Skander Thabet on 18/4/2022.
//

import UIKit
import CoreMedia
import AVKit

// MARK: - UIKit Extensions

extension UIViewController {
  public func displayError(_ error: Error?, from function: StaticString = #function) {
    guard let error = error else { return }
    print("ⓧ Error in \(function): \(error.localizedDescription)")
    let message = "\(error.localizedDescription)\n\n Ocurred in \(function)"
    let errorAlertController = UIAlertController(
      title: "Error",
      message: message,
      preferredStyle: .alert
    )
    errorAlertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(errorAlertController, animated: true, completion: nil)
  }
}



extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self :
        self.replacingOccurrences(of: "http", with: "https")
    }
    
}

extension CMTime {
    func toDisplayString() -> String {
        if(CMTimeGetSeconds(self).isNaN){
            return "--:--"
        }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
}

extension PlayerDetailsView {
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    
    fileprivate func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.miniPlayerView.alpha = 1 + translation.y / 200
        self.maximizedStackPlayerView.alpha = -translation.y / 200
    }
    
    fileprivate func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.transform = .identity
            if translation.y < -200  || velocity.y < -500 {
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil)
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackPlayerView.alpha = 0
            }
            
        }
    }
    
    @objc func handleTapMaximize() {
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil)
        print("Tapping to maximize")
        
    }
}
