//
//  UIApplication.swift
//  Vox
//
//  Created by Skander Thabet on 26/4/2022.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarViewController? {
        return shared.keyWindow?.rootViewController as? MainTabBarViewController
    }
}
