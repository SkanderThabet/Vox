//
//  NewAccount.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import Foundation

public class NewAccount: Codable {
    
  // MARK: - Properties
    public let email: String
    public let password: String
    public let firstname: String
    public let lastname: String
    public let dob: String
    public let avatar: URL
    
    // MARK: - Methods
    public init(email: String, password: String, firstname: String, lastname: String, dob: String, avatar: URL) {
        self.email = email
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
        self.dob = dob
        self.avatar = avatar
    }
  
    
    
}
