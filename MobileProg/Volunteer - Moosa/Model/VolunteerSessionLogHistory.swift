//
//  SessionLog.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/14/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import Foundation

class VolunteerSessionLogHistory {
    
    //Properties
    
    var date: String
    var requestedCall: Bool
    var seekerId: String
    var seekerName: String
    var seekerRating: Int
    var sessionID: String
    var volunteerID: String
    var volunteerName: String
    var volunteerRating: Int
    var ended: Bool
    
    //Initialization
    init?(date: String, requestedCall: Bool, seekerId: String, seekerName: String, seekerRating: Int, sessionID: String, volunteerID: String, volunteerName: String, volunteerRating: Int, ended: Bool) {
        
        // The date must not be empty
        guard !date.isEmpty else {
            return nil
        }
        
        
        // The seekerId must not be empty
        guard !seekerId.isEmpty else   {
            return nil
        }
        
        // The seekerName must not be empty
        guard !seekerName.isEmpty else   {
            return nil
        }
        
        // The sessionID must not be empty
        guard !sessionID.isEmpty else   {
            return nil
        }
        
        // The volunteerID must not be empty
        guard !volunteerID.isEmpty else   {
            return nil
        }
        
        // The volunteerName must not be empty
        guard !volunteerName.isEmpty else   {
            return nil
        }
        
        
        
        // Initialize stored properties.
        self.date = date
        self.requestedCall = requestedCall
        self.seekerId = seekerId
        self.seekerName = seekerName
        self.seekerRating = seekerRating
        self.sessionID = sessionID
        self.volunteerID = volunteerID
        self.volunteerName = volunteerName
        self.volunteerRating = volunteerRating
        self.ended = ended
        
    }
}
