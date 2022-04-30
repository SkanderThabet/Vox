//
//  TokenService.swift
//  Vox
//
//  Created by Skander Thabet on 28/4/2022.
//

import UIKit

class TokenService {

    static let tokenInstance = TokenService()
    let userDefault = UserDefaults.standard
    func saveToken(token: String) {
        userDefault.set(token, forKey: TokenKey.userLogin)
    }
    func getToken() -> String {
        if let token = userDefault.object(forKey: TokenKey.userLogin) as? String{
            return token
        } else {
            return ""
        }
    }
    
    func checkForLogin() -> Bool {
        if getToken() == "" {
            return false
        } else {
            return true
        }
    }
    
    func removeToken() {
        userDefault.removeObject(forKey: TokenKey.userLogin)
    }

}
