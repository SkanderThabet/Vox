//
//  UserProfile.swift
//  Vox
//
//  Created by Skander Thabet on 12/4/2022.
//

import Foundation

public struct UserProfile : Codable {
    
  // MARK: - Properties
    public let firstname: String
    public let lastname : String
    public let dob: String
    public let username: String
    public let email: String
    public let avatar: URL
    
  // MARK: - Methods
  public init(firstname: String, lastname: String, dob: String, username: String, email: String, avatar: URL) {
      self.firstname = firstname
      self.lastname = lastname
      self.dob = dob
      self.username = username
      self.email = email
      self.avatar = avatar
  }
    
    
}
