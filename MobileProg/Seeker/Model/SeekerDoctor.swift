//
//  Doctor.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/18/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import Foundation
class SeekerDoctor {
    var email:String?
    var isReported: Bool?
    var name : String?
    var phoneNumber : String?
    var clincName : String?
    var clincCity :  String?
    var clincBlock : String?
    var clincStreet :  String?
    var clincBuidling : String?
    var picturePath : String?
    var speciality : String?
    var username : String?
    var doctorID :String?
    
    init?(email:String, isReported: Bool,name : String,phoneNumber : String,clincName : String
    ,clincCity :  String
,clincBlock : String,clincStreet :  String,clincBuidling : String, picturePath : String, speciality : String,username : String,doctorID :String?) {
        
        // The email must not be empty
        guard !email.isEmpty else {
            return nil
        }

}
}
