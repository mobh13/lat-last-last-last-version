//
//  VolunteerQuizDetailsTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/1/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class VolunteerQuizDetailsTableViewController: UITableViewController, UITextFieldDelegate {

    var qID = ""
    var answers:[QuizAnswersDoctor] = []
    @IBOutlet var allTexts: [UITextField]!
    @IBOutlet var allSwitches: [UISwitch]!
    @IBOutlet weak var switchOne: UISwitch!
    @IBOutlet weak var switchThree: UISwitch!
    @IBOutlet weak var txtThree: UITextField!
    @IBOutlet weak var switchTwo: UISwitch!
    @IBOutlet weak var txtTwo: UITextField!
    @IBOutlet weak var txtOne: UITextField!
    @IBOutlet weak var txtQuestion: UITextField!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtOne.delegate = self
        self.txtTwo.delegate = self
        self.txtThree.delegate = self
        self.txtQuestion.delegate = self
        if(!qID.isEmpty){
            let quesdb = Database.database().reference().child("Questions")
            quesdb.child(qID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let ques = value?["Question"] as? String {
                   self.txtQuestion.text = ques
                }else{
                     self.txtQuestion.text = "Invalid Question"
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            let ansdb = Database.database().reference().child("Answers")
            ansdb.queryOrdered(byChild: "QuestionID").queryEqual(toValue: qID).observe(.value) { (snapshot) in
                for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                    let value = child.value as! NSDictionary
                    let ans = QuizAnswersDoctor()
                    ans.answerID = child.key
                    if let answer = value.value(forKey: "Answer") as? String {
                         ans.Answer = answer
                    }
                    if let isCorrect = value.value(forKey: "Correct") as? Bool {
                        ans.Correct = isCorrect
                    }
                    if let id = value.value(forKey: "QuestionID") as? String {
                        ans.QuestionID = id
                    }
                    self.answers.append(ans)
                }
                DispatchQueue.main.async {
                    if(!self.answers.isEmpty && self.answers.count == 3){
                        self.txtOne.text = self.answers[0].Answer
                        self.txtTwo.text = self.answers[1].Answer
                        self.txtThree.text = self.answers[2].Answer
                        self.switchOne.setOn(self.answers[0].Correct!, animated: true)
                        self.switchTwo.setOn(self.answers[1].Correct!, animated: true)
                        self.switchThree.setOn(self.answers[2].Correct!, animated: true)
                    }else{
                        let alert = UIAlertController(title: "Error", message: "The question and corresponding answers are corrupt. Please Enter a new questions and answers.", preferredStyle: .alert)
                        let nextAction = UIAlertAction(title: "Okay!", style: .default) { action in
                            for textField in self.allTexts {
                                textField.text = ""
                            }
                            for switches in self.allSwitches {
                                switches.setOn(false, animated: true)
                            }
                            self.qID = ""
                            self.answers.removeAll()
                        }
                        alert.addAction(nextAction)
                        self.present(alert, animated: true)
                    }
            }
            }

        }
    }
    @IBAction func btnDone(_ sender: Any) {
        var validText = true
        var checked = 0
        for textField in self.allTexts {
            if !textField.hasText {
                validText = false
            }
        }
        for switches in self.allSwitches {
            if switches.isOn {
                checked += 1
            }
        }
        if (validText && checked == 1){
            if(self.qID.isEmpty){
                let quesdb = Database.database().reference().child("Questions");
                let queskey = Database.database().reference().childByAutoId().key
                let quesDB = [
                    "Question" : self.txtQuestion.text!,
                    "Type" : "Quiz"
                ]
                quesdb.child(queskey!).setValue(quesDB)
                addAnswer(answer: self.txtOne.text!, correct: self.switchOne.isOn, quesKey: queskey!)
                addAnswer(answer: self.txtTwo.text!, correct: self.switchTwo.isOn, quesKey: queskey!)
                addAnswer(answer: self.txtThree.text!, correct: self.switchThree.isOn, quesKey: queskey!)
            }else{
                let quesdb = Database.database().reference().child("Questions")
                quesdb.child("\(self.qID)/Question").setValue(self.txtQuestion.text!)
                let ansdb = Database.database().reference().child("Answers")
                //the following cannot be done in a different way because the set value arguments are alays changing
                ansdb.child("\(self.answers[0].answerID!)/Answer").setValue(self.txtOne.text!)
                ansdb.child("\(self.answers[0].answerID!)/Correct").setValue(self.switchOne.isOn)
                ansdb.child("\(self.answers[1].answerID!)/Answer").setValue(self.txtTwo.text!)
                ansdb.child("\(self.answers[1].answerID!)/Correct").setValue(self.switchTwo.isOn)
                ansdb.child("\(self.answers[2].answerID!)/Answer").setValue(self.txtThree.text!)
                ansdb.child("\(self.answers[2].answerID!)/Correct").setValue(self.switchThree.isOn)
            }
            let alert = UIAlertController(title: "Success", message: "The question and answers have been added to the system.", preferredStyle: .alert)
            let nextAction = UIAlertAction(title: "Okay!", style: .default) { action in
                 self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(nextAction)
            self.present(alert, animated: true)
        }else{
            if !validText{
                let alert = UIAlertController(title: "Invalid Input", message: "Please make sure that all fields are filled and with valid information.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                self.present(alert, animated: true)
            }else{
                let alert = UIAlertController(title: "Invalid Check", message: "Please make sure to choose only one correct answer as these will be used in a multichoice questions format", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    func addAnswer(answer : String, correct : Bool, quesKey : String){
        let db = Database.database().reference().child("Answers")
        let ansDB = [
            "Answer" : answer,
            "Correct" : correct,
            "QuestionID" : quesKey
            ] as [String : Any]
        db.childByAutoId().setValue(ansDB)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section{
        case 0:
            return 1
        case 1:
            return 6
        default:
            return 1
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        
        cell.quizQuestion.text = questions[indexPath.row]
        

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
