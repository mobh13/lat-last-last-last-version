//
//  Appointment.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/1/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import Foundation
import Firebase

class Appointment{
    var appointmentID : String?
    var Date : Date?
    var Time : String?
    var Description : String?
    var doctorID : String?
    var seekerID : String?
    var doctorRate : Int?
    var seekerRate : Int?
    var seekerName :  String?
    
    func getDateTime() -> String{
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy"
        let formattedDate = format.string(from: self.Date!)
        return "\(formattedDate) - \(self.Time!)"
    }
}
