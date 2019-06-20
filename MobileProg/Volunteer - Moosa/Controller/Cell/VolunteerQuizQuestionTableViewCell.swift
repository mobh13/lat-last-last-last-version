//
//  QuizQuestionTableViewCell.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/11/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class VolunteerQuizQuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var answerButtons: [UIButton]!
    
    
    @IBAction func firstAnswerChosen(_ sender: Any) {
        answerButtons[0].isEnabled = false
        answerButtons[1].isEnabled = true
        answerButtons[2].isEnabled = true
    }
    
    @IBAction func secondAnswerChosen(_ sender: Any) {
        answerButtons[0].isEnabled = true
        answerButtons[1].isEnabled = false
        answerButtons[2].isEnabled = true
    }
    
    @IBAction func thirdAnswerChosen(_ sender: Any) {
        answerButtons[0].isEnabled = true
        answerButtons[1].isEnabled = true
        answerButtons[2].isEnabled = false
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
