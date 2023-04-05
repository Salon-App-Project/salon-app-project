//
//  AppDelegate.swift
//  BeReal Clone
//
//  Created by Ruth Bilaro 3/18/23.


import Foundation
import ParseSwift

struct Post: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // custom properties.
    var caption: String?
    var user: User?
    var imageFile: ParseFile?
    var location: String?
}
