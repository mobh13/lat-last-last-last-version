//
//  ReportsListTableViewCell.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/14/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class ReportsListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
