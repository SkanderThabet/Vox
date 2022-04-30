//
//  UserProfile.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import Foundation

// MARK: - UserProfile
struct UserProfile: Codable {
    let success: Bool
    let msg, token: String
    let user: User
}

// MARK: - User
struct User: Codable {
    let id, username, email, firstname: String
    let lastname, dob: String
    let avatar: String
    let v: Int
    let updatedAt, password: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username, email, firstname, lastname, dob, avatar
        case v = "__v"
        case updatedAt, password
    }
}

