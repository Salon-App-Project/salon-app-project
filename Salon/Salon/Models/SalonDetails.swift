
import Foundation
import ParseSwift

struct SalonDetails: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // custom properties.
    var user:User?
    var phone: String?
    var address: String?
    var email: String?
    var city: String?
    var state: String?
    var zipcode: String?
    var imageFile: ParseFile?
}
