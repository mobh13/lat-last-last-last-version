//
//  HelpedSeekersTableViewCell.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/14/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class VolunteerHelpedSeekersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seekerName: UILabel!
    
    @IBOutlet weak var helpHistory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
