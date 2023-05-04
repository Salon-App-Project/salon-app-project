//
//  AppUser.swift
//  SalonAppProject
//
//  Created by Alex Rivas on 3/22/23.
//

import Foundation
import ParseSwift
struct AppUser :ParseUser{
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String : [String : String]?]?
    var Usersname:String?
    var taxid:String?
    var phonenumber:String?
    var subscriptionstatus:Bool?
    
}
