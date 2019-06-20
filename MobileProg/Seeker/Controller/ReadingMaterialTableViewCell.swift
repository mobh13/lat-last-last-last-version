//
//  ReadingMaterialTableView Cell.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/18/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class ReadingMaterialTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblmaterialtitle: UILabel!
  
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
