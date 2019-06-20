//
//  Volunteer.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/11/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import Foundation

class VolunteerVolunteer {
    
    //Properties
    
    var username: String
    var email: String
    var password: String
    var fullName: String
    var phoneNumber: String
    var CPRNumber: String
    var DOB: String
    var picturePath: String

    
    //Initialization
    init?(username: String, email: String, password: String, fullName: String, phoneNumber: String, CPRNumber: String, DOB: String, picturePath: String) {
        
        // The username must not be empty
        guard !username.isEmpty else {
            return nil
        }
        
        // The email must not be empty
        guard !email.isEmpty else {
            return nil
        }
        
        // The password must not be empty
        guard !password.isEmpty else {
            return nil
        }
        
        // The fullName must not be empty
        guard !fullName.isEmpty else {
            return nil
        }
        
        // The phoneNumber must not be empty
        guard !phoneNumber.isEmpty else {
            return nil
        }
        
        // The CPRNumber must not be empty
        guard !CPRNumber.isEmpty else {
            return nil
        }
        
        // The DOB must not be empty
        guard !DOB.isEmpty else {
            return nil
        }
        
        // The picturePath must not be empty
        guard !picturePath.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.username = username
        self.email = email
        self.password = password
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.CPRNumber = CPRNumber
        self.DOB = DOB
        self.picturePath = picturePath
    }
    
}
