//
//  AppointmentsListTableViewCell.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/20/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class AppointmentsListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDoc: UILabel!
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
