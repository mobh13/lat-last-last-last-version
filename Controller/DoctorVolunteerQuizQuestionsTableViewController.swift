//
//  VolunteerQuizQuestionsTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/1/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class DoctorVolunteerQuizQuestionsTableViewController: UITableViewController {

    var questions = [QuizQuestions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func loadQuestions(){
        self.questions.removeAll()
        let ref = Database.database().reference().child("Questions")
        ref.queryOrdered(byChild: "Type").queryEqual(toValue: "Quiz").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                let value = child.value as! NSDictionary
                let ques = QuizQuestions()
                ques.QuestionID = child.key
                if let quesText = value.value(forKey: "Question") as? String {
                    ques.Question = quesText
                }
                self.questions.append(ques)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
       loadQuestions()
    }
    
    @IBAction func addQuestion(_ sender: Any) {
        let s = UIStoryboard(name: "Doctor", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "volunteerQuizQuestionDetails") as! VolunteerQuizDetailsTableViewController
        vc.qID = ""
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizQuestionCell", for: indexPath) as! QuizCell
        cell.quizQuestion.text = questions[indexPath.row].Question
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            let s = UIStoryboard(name: "Doctor", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "volunteerQuizQuestionDetails") as! VolunteerQuizDetailsTableViewController
            vc.qID = self.questions[indexPath.row].QuestionID!
            self.navigationController!.pushViewController(vc, animated: true)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            var answerKeys = [String]()
            if let quesID = self.questions[indexPath.row].QuestionID {
                Database.database().reference().child("Questions").child(quesID).removeValue()
                let ref = Database.database().reference().child("Answers")
                ref.queryOrdered(byChild: "QuestionID").queryEqual(toValue: quesID).observeSingleEvent(of: .value, with: { (snapshot) in
                    for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                        answerKeys.append(child.key)
                    }
                })
                for answer in answerKeys {
                    Database.database().reference().child("Answers").child(answer).removeValue()
                }
                self.loadQuestions()
            }
        }
        deleteAction.backgroundColor = .red
        
        return [editAction,deleteAction]
    }
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
