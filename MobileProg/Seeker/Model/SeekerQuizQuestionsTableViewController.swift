//
//  SeekerQuizQuestionsTableViewController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/17/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class SeekerQuizQuestionsTableViewController: UITableViewController {

    var questions = [sessionQuestion]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadQuestions()
    }
    
    func loadQuestions(){
        self.questions.removeAll()
        let ref = Database.database().reference().child("Questions")
        ref.queryOrdered(byChild: "Type").queryEqual(toValue: "PreSessionQuizData").observeSingleEvent(of: .value, with: {
            (snapshot)in
            for child in (snapshot.children.allObjects as? [DataSnapshot])!{
                let value = child.value as! NSDictionary
                var ques = sessionQuestion()
                ques.QuetionID = child.key
                
                ques.Question = value.value(forKey: "PreSessionQuizData") as? String
                
                self.questions.append(ques)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    func loadAnswers(){
        
    }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    

    // MARK: - Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
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



