//
//  EditQuestionTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/12/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class EditQuestionTableViewController: UITableViewController,UITextFieldDelegate {

    @IBOutlet weak var txtQuestion: UITextField!
    @IBOutlet weak var txtAnswer1: UITextField!
    @IBOutlet weak var txtAnswer2: UITextField!
    @IBOutlet weak var txtAnswer3: UITextField!
    @IBOutlet weak var isCorrect1: UISwitch!
    @IBOutlet weak var isCorrect2: UISwitch!
    @IBOutlet weak var isCorrect3: UISwitch!
    
    var seekerQuestion = false
    var id:String?
    let db =  Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtQuestion.delegate = self
        txtAnswer1.delegate = self
        txtAnswer2.delegate = self
        txtAnswer3.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        loadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    func loadData(){
        if self.id != nil {
            db.child("Questions").child(self.id!).observeSingleEvent(of: .value, with: {(snapshot) in
                if  let val = snapshot.value as? NSDictionary{
                    
                    let question = val.value(forKey: "Question") as! String
                    let type = val.value(forKey: "Type") as! String
                    
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
                                        if  let answer = row.value(forKey: "Answer") as? String {
                                            if counter == 0 {
                                                self.txtAnswer1.text = answer
                                                
                                            } else if  counter == 1 {
                                                self.txtAnswer2.text = answer
                                            }
                                            else if counter == 2 {
                                                self.txtAnswer3.text = answer
                                            }
                                        }
                                        if  let correct = row.value(forKey: "Correct") as? Bool {
                                            if counter == 0 {
                                                self.isCorrect1.isOn = correct
                                                
                                            } else if  counter == 1 {
                                                self.isCorrect2.isOn = correct
                                            }
                                            else if counter == 2 {
                                                self.isCorrect3.isOn = correct
                                            }
                                        }
                                      
                                        
                                        counter = counter + 1;
                                        
                                    }}
                                self.tableView.reloadData()
                                
                            }})
                        
                    }
                    self.txtQuestion.text  = question
                    
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
    @IBAction func updateClicked(_ sender: Any) {
      
            
        
            guard let question = txtQuestion.text , question.count > 3 else {
                
                let alert = UIAlertController(title: "Error", message: "Question Can't be Empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert,animated: true)
                return
            }
            if !self.seekerQuestion  {
                var countanswers = 0
                
                if(txtAnswer1.text != nil && txtAnswer1.text!.count > 1 ){countanswers = countanswers + 1}
                if(txtAnswer2.text != nil && txtAnswer2.text!.count > 1){countanswers = countanswers + 1}
                if(txtAnswer3.text != nil && txtAnswer3.text!.count > 1){countanswers = countanswers + 1}
                
                guard  countanswers == 3 else {
                    
                    let alert = UIAlertController(title: "Error", message: "You must have 3 answers", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert,animated: true)
                    return
                }
                
                var countCorrect = 0
                
                if(isCorrect1.isOn){countCorrect = countCorrect + 1}
                if(isCorrect2.isOn){countCorrect = countCorrect + 1}
                if(isCorrect3.isOn){countCorrect = countCorrect + 1}
                
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
                
                db.child("Questions").child(self.id!).child("Question").setValue(question)
                let query = self.db.child("Answers").queryOrdered(byChild: "QuestionID").queryEqual(toValue: self.id!)
                query.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    if  let val = snapshot.value as? NSDictionary{
                        var counter = 0
                        for key in (val.keyEnumerator()){
                            if  (val.value(forKey: key as! String) as? NSDictionary) != nil{
                              
                                if counter == 0 {
                                    self.db.child("Answers").child(key as! String).child("Answer").setValue(self.txtAnswer1.text!)
                                     self.db.child("Answers").child(key as! String).child("Correct").setValue( self.isCorrect1.isOn)
                                    
                                  
                                    
                                } else if  counter == 1 {
                                    self.db.child("Answers").child(key as! String).child("Answer").setValue(self.txtAnswer2.text!)
                                    self.db.child("Answers").child(key as! String).child("Correct").setValue( self.isCorrect2.isOn)
                                }
                                else if counter == 2 {
                                    self.db.child("Answers").child(key as! String).child("Answer").setValue(self.txtAnswer3.text!)
                                    self.db.child("Answers").child(key as! String).child("Correct").setValue( self.isCorrect3.isOn)
                                }
                                
                                counter = counter + 1;
                                
                            }}
                        self.tableView.reloadData()
                        
                    }})
              
                
                let alert = UIAlertController(title: "Added", message: "Question Updated !!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {(action) in
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert,animated: true)
                
                
                
                
            } else if self.seekerQuestion {
                
              db.child("Questions").child(self.id!).child("Question").setValue(question)
                let alert = UIAlertController(title: "Added", message: "Question Updated !!", preferredStyle: .alert)
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
