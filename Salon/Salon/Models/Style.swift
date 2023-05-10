import Foundation
import ParseSwift

struct Style: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // custom properties.
    var user:User?
    var stylename: String?
    var styleprice: String?
    var styledescription: String?
    var imageFile: ParseFile?
}
