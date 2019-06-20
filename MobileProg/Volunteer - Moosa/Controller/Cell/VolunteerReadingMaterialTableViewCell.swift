//
//  ReadingMaterialTableViewCell.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/10/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class VolunteerReadingMaterialTableViewCell: UITableViewCell {
    
    @IBOutlet weak var materialTitle: UILabel!
    
    @IBOutlet weak var materialDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
