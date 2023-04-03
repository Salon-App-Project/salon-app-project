//
//  Service.swift
//  SalonAppProject
//
//  Created by user230516 on 3/29/23.
//

import Foundation
import ParseSwift

struct Service: ParseObject {
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
    var id: Int?
    var name: String?
    var price: Decimal?
    var duration: Int?
    var business_id: Int? //(foreign key referencing Business)
    
    var Appointment_id: Int?
    
    var customer_id: Int?
    
    var service_id: Int? //(foreign key referencing Service)
    
    var date_time: Date?
    
    enum status {
        case booked
        case cancelled
        case completed
    }
    enum gender {
        case male
        case female
        case other
    }
    enum cancelled_by {
        case customer
        case business
        case null
    }
