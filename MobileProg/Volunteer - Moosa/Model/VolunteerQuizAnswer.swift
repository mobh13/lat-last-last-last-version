//
//  quizAnswer.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/11/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import Foundation

class VolunteerQuizAnswer {
    
    //Properties
    
    var answer: String
    var correct: String
    var questionID: String
    
    //Initialization
    init?(answer: String, correct: String, questionID: String) {
        
        // The answer must not be empty
        guard !answer.isEmpty else {
            return nil
        }
        
        // The correct must not be empty
        guard !correct.isEmpty else  {
            return nil
        }
        
        // The questionID must not be empty
        guard !questionID.isEmpty else   {
            return nil
        }
        
        // Initialize stored properties.
        self.answer = answer
        self.correct = correct
        self.questionID = questionID
    }
}
