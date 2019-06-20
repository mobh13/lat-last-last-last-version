//
//  Seeker.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/12/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import Foundation

class VolunteerSeeker {
    
    //Properties
    
    var email: String
    var isReported: Bool
    var name: String
    var picturePath: String
    var role: String
    var username: String
    var phoneNumber: String
    var requestedVolunteer: String
    var seekerId: String
    
    //Initialization
    init?(email: String, isReported: Bool, name: String, picturePath: String, role: String, username: String, phoneNumber: String, requestedVolunteer: String, seekerId: String) {
        
        // The email must not be empty
        guard !email.isEmpty else {
            return nil
        }
        
        
        // The name must not be empty
        guard !name.isEmpty else   {
            return nil
        }
        
        // The picturePath must not be empty
        guard !picturePath.isEmpty else   {
            return nil
        }
        
        // The role must not be empty
        guard !role.isEmpty else   {
            return nil
        }
        
        // The username must not be empty
        guard !username.isEmpty else   {
            return nil
        }
        
        // The phoneNumber must not be empty
        guard !phoneNumber.isEmpty else   {
            return nil
        }
        
        // The requestedVolunteer must not be empty
        guard !requestedVolunteer.isEmpty else   {
            return nil
        }
        
        // The seekerId must not be empty
        guard !seekerId.isEmpty else   {
            return nil
        }
        
        // Initialize stored properties.
        self.email = email
        self.isReported = isReported
        self.name = name
        self.picturePath = picturePath
        self.role = role
        self.username = username
        self.phoneNumber = phoneNumber
        self.requestedVolunteer = requestedVolunteer
        self.seekerId = seekerId
        
    }
}
