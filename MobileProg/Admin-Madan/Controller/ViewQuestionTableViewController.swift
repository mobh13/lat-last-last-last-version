//
//  ViewQuestionTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/12/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class ViewQuestionTableViewController: UITableViewController {

    
    
    @IBOutlet weak var questionValLabel: UILabel!
    @IBOutlet weak var targetValLabel: UILabel!
    @IBOutlet weak var answer1Label: UILabel!
    @IBOutlet weak var answer1IsCorrect: UISwitch!
    @IBOutlet weak var answer2Label: UILabel!
    @IBOutlet weak var answer2IsCorrect: UISwitch!
    @IBOutlet weak var answer3Label: UILabel!
    @IBOutlet weak var answer3IsCorrect: UISwitch!
    
    
    var seekerQuestion = false
    var id:String?
    let db =  Database.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        loadData()
    }
    func loadData(){
        if self.id != nil {
        db.child("Questions").child(self.id!).observeSingleEvent(of: .value, with: {(snapshot) in
            if  let val = snapshot.value as? NSDictionary{
              
                if let question = val.value(forKey: "Question") as? String{
                    
                    if let type = val.value(forKey: "Type") as? String{
                    
                        if type == "Survay" {
                            
                            self.seekerQuestion = true
                            self.tableView.reloadData()
                        }else{
                            let query = self.db.child("Answers").queryOrdered(byChild: "QuestionID").queryEqual(toValue: self.id!)
                            query.observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                
                                if  let val = snapshot.value as? NSDictionary{
                                    var counter = 0
                                    for key in (val.keyEnumerator()){
                                        if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                            if let answer = row.value(forKey: "Answer") as? String {
                                                if counter == 0 {
                                                    self.answer1Label.text = answer
                                                    
                                                    
                                                } else if  counter == 1 {
                                                    self.answer2Label.text = answer
                                                
                                                }
                                                else if counter == 2 {
                                                    self.answer3Label.text = answer
                                                    
                                                }
                                            }
                                            if let correct = row.value(forKey: "Correct") as? Bool{
                                                if counter == 0 {
                                                    self.answer1IsCorrect.isOn = correct
                                                    
                                                } else if  counter == 1 {
                                                   
                                                    self.answer2IsCorrect.isOn = correct
                                                }
                                                else if counter == 2 {
                                                    self.answer3IsCorrect.isOn = correct
                                                }
                                            }
                                          
                                            
                                            counter = counter + 1;
                                            
                                        }}
                                    self.tableView.reloadData()
                                    
                                }})
                            
                        }
                        self.questionValLabel.text  = question
                        self.targetValLabel.text = type
                    }
                }
               
                
                
                
            }}
            )
            
        
   
    }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.seekerQuestion {
            return 1
            
        }else {
             return 2
        }
    }

    @IBAction func editClicked(_ sender: Any) {
        
        let s = UIStoryboard(name: "Admin", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "EditQuestionTableViewController") as! EditQuestionTableViewController
        vc.id = self.id
        
        self.navigationController?.pushViewController(vc, animated: true)
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
