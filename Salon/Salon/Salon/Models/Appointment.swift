
import Foundation
import ParseSwift

struct Appointment: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // custom properties.
    var user:User?
    var style: Style?
    var date: Date?
    var name: String?
    var phone: String?
    
}
