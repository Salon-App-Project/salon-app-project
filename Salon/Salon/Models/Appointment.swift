
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
    var salondetail: SalonDetails?
    var userdetail: UserDetails?
    var style: Style?
    var appointmentdate: Date?
    var customername: String?
    var customerphone: String?
    var status: String?
}
