//
//  SurveyDetailsQuestionTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/1/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class SurveyDetailsQuestionTableViewController: UITableViewController, UITextFieldDelegate {
    var quesID = ""
    @IBOutlet weak var lblQuestion: UITextField!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblQuestion.delegate = self
        if(!quesID.isEmpty){
            let quesdb = Database.database().reference().child("Questions")
            quesdb.child(quesID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let question = value?["Question"] as? String {
                    self.lblQuestion.text = question
                }else{
                     self.lblQuestion.text = "Invalid question."
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func btnDone(_ sender: Any) {
        if(self.lblQuestion.text != nil){
            if(self.quesID.isEmpty){
                let quesdb = Database.database().reference().child("Questions");
                let quesDB = [
                    "Question" : self.lblQuestion.text!,
                    "Type" : "Survey"
                ]
                quesdb.childByAutoId().setValue(quesDB)
            }else{
                let quesdb = Database.database().reference().child("Questions")
                quesdb.child("\(self.quesID)/Question").setValue(self.lblQuestion.text!)
                
            }
            let alert = UIAlertController(title: "Success", message: "The question has been added to the system.", preferredStyle: .alert)
            let nextAction = UIAlertAction(title: "Okay!", style: .default) { action in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(nextAction)
            self.present(alert, animated: true)
        }else{
            let alert = UIAlertController(title: "Invalid Input", message: "Please make sure that question field is filled with valid information.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
