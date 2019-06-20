//
//  ReadingMaterial.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/18/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import Foundation
class ReadingMaterial {
    
    //Properties
    
    var title: String
    var description: String
    var link: String
    var id:String?
    //Initialization
    init?(title: String, description: String, link: String) {
        
        // The name must not be empty
        guard !title.isEmpty else {
            return nil
        }
        
        // The link must not be empty
        guard !link.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.title = title
        self.description = description
        self.link = link
    }
}
