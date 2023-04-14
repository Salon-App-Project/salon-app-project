

import Foundation
import ParseSwift

struct User: ParseUser {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // These are required by `ParseUser`.
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?

    // custom properties.
    var phone: String?
    var address: String?
    var city: String?
    var state: String?
    var zipcode: String?
    var usertype: String?
    var imageFile: ParseFile?
    var imageFile2: ParseFile?
    var imageFile3: ParseFile?
}
