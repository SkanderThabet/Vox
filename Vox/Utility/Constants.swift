//
//  Constants.swift
//  Vox
//
//  Created by Skander Thabet on 27/4/2022.
//

import Foundation

enum ApiError : Error {
    case customMessage(message:String)
}

typealias Handler = (Swift.Result<Any?,ApiError>) -> Void

struct TokenKey {
    static let userLogin = ""
}

var fullName, firstName, lastName , status, userName , email , dob , avatar: String?

struct Preference {
    static var defaultInstance = Preference()
    
    
    var uri: String? = "rtmp://172.17.4.125/live"
    var streamName: String? = "live"
}
    


