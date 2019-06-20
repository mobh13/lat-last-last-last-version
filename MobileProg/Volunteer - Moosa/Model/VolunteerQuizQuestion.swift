//
//  Question.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/11/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import Foundation

class VolunteerQuizQuestion {
    
    //Properties
    
    var question: String
    var type: String
    var key: String
    
    //Initialization
    init?(question: String, type: String, key: String) {
        
        // The question must not be empty
        guard !question.isEmpty else {
            return nil
        }
        
        // The type must not be empty
        if type.isEmpty  {
            return nil
        }
        
        // The type must not be empty
        if key.isEmpty  {
            return nil
        }
        
        // Initialize stored properties.
        self.question = question
        self.type = type
        self.key = key
    }
}
