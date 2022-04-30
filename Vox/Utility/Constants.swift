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
