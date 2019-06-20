//
//  LogCell.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/24/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
