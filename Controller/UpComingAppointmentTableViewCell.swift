//
//  UpComingAppointmentTableViewCell.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/12/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class UpComingAppointmentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
