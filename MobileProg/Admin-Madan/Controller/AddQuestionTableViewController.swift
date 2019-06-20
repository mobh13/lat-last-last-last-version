//
//  AddQuestionTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/29/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class AddQuestionTableViewController: UITableViewController ,UITextFieldDelegate{

    @IBOutlet weak var questiontxtF: UITextField!
    @IBOutlet weak var questionTarget: UISegmentedControl!
    @IBOutlet weak var iscorrectAnswer1: UISwitch!
    @IBOutlet weak var answertxtF1: UITextField!
    @IBOutlet weak var iscorrectAnswer2: UISwitch!
    @IBOutlet weak var answertxtF2: UITextField!
    @IBOutlet weak var iscorrectAnswer3: UISwitch!
    @IBOutlet weak var answertxtF3: UITextField!
    
    let db = Database.database().reference()
    var noSections = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        questiontxtF.delegate = self
        answertxtF1.delegate=self
        answertxtF2.delegate = self
        answertxtF3.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return noSections
    }

    
    @IBAction func filterClicked(_ sender: Any) {
        
        if questionTarget.selectedSegmentIndex == 1 {
            
            self.noSections = 1
        }else{
            self.noSections = 2
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        
        let  selectedIndex = questionTarget.selectedSegmentIndex
        guard selectedIndex != -1  else {
            
            let alert = UIAlertController(title: "Error", message: "You Must select a target for your question", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert,animated: true)
            return
        }
        guard let question = questiontxtF.text , question.count > 3 else {
            
            let alert = UIAlertController(title: "Error", message: "Question Can't be Empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert,animated: true)
            return
        }
        if selectedIndex == 0 {
            var countanswers = 0
            
            if(answertxtF1.text != nil && answertxtF1.text!.count > 1 ){countanswers = countanswers + 1}
            if(answertxtF2.text != nil && answertxtF2.text!.count > 1){countanswers = countanswers + 1}
            if(answertxtF3.text != nil && answertxtF3.text!.count > 1){countanswers = countanswers + 1}
            
            guard  countanswers == 3 else {
                
                let alert = UIAlertController(title: "Error", message: "You must have 3 answers", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert,animated: true)
                return
            }
            
            var countCorrect = 0
            
            if(iscorrectAnswer1.isOn){countCorrect = countCorrect + 1}
            if(iscorrectAnswer2.isOn){countCorrect = countCorrect + 1}
            if(iscorrectAnswer3.isOn){countCorrect = countCorrect + 1}
            
            guard countCorrect == 1   else {
                if countCorrect > 1 {
                    let alert = UIAlertController(title: "Error", message: "You Must select only one correct answer for your question", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert,animated: true)
                }else{
                    let alert = UIAlertController(title: "Error", message: "You Must select a correct answer for your question", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert,animated: true)
                }
                
                return
            }
            
            let childKey  = db.child("Questions").childByAutoId().key!
          let questionToInsert :
            NSDictionary =
            ["Question" : question,
             "Type" : "Quiz"
            
            ]
            db.child("Questions").child(childKey).setValue(questionToInsert)
            
            let Answer1: NSDictionary =
                ["Answer" : answertxtF1.text!,
                 "Correct" : iscorrectAnswer2.isOn,
                 "QuestionID" : childKey
            ]
            let Answer2: NSDictionary =
                ["Answer" : answertxtF2.text!,
                 "Correct" : iscorrectAnswer1.isOn,
                 "QuestionID" : childKey
            ]
            let Answer3: NSDictionary =
                ["Answer" : answertxtF3.text!,
                 "Correct" : iscorrectAnswer3.isOn,
                 "QuestionID" : childKey
            ]
            
           db.child("Answers").childByAutoId().setValue(Answer1)
            db.child("Answers").childByAutoId().setValue(Answer2)
            db.child("Answers").childByAutoId().setValue(Answer3)
            
            let alert = UIAlertController(title: "Added", message: "Question Added !!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {(action) in
                
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert,animated: true)
            
            
            
            
        } else if selectedIndex == 1 {
            
            let questionToInsert :
                NSDictionary =
                ["Question" : question,
                 "Type" : "Survay"
                    
            ]
            db.child("Questions").childByAutoId().setValue(questionToInsert)
            let alert = UIAlertController(title: "Added", message: "Question Added !!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {(action) in
                
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert,animated: true)
            
        }
       
      
        
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
