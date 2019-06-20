//
//  QuestionsTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/25/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class QuestionsTableViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet weak var filter: UISegmentedControl!
    
    var searchActive : Bool = false
    var questions:[Question] = []
        var questionsFilterd:[Question] = []
    let db =  Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func loadData(){
        
        if filter.selectedSegmentIndex == 0 {
            let query = db.child("Questions").queryOrdered(byChild: "Type").queryEqual(toValue: "Quiz")
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                self.questions.removeAll()
                
                if  let val = snapshot.value as? NSDictionary{
                    for key in (val.keyEnumerator()){
                        if  let row = val.value(forKey: key as! String) as? NSDictionary{
                            
                            let id = key as! String
                            if let question = row.value(forKey: "Question") as? String, let type = row.value(forKey: "Type") as? String{
                                let q = Question(id: id, question: question, type: type)
                                self.questions.append(q)
                            }
                            
                          
                            
                        }}
                    self.tableView.reloadData()
                    
                }})
        }else{
            
            let query = db.child("Questions").queryOrdered(byChild: "Type").queryEqual(toValue: "Survey")
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                self.questions.removeAll()
                
                if  let val = snapshot.value as? NSDictionary{
                    for key in (val.keyEnumerator()){
                        if  let row = val.value(forKey: key as! String) as? NSDictionary{
                            
                            let id = key as? String
                            if let question = row.value(forKey: "Question") as? String, let type = row.value(forKey: "Type") as? String{
                                let q = Question(id: id, question: question, type: type)
                                self.questions.append(q)

                            }
                        }}
                    self.tableView.reloadData()
                    
                }
            self.tableView.reloadData()
            }
            )
        }
    }
    @IBAction func filterClicked(_ sender: Any) {
        
        loadData()
        
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        let s = UIStoryboard(name: "Admin", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "AddQuestionTableViewController") as! AddQuestionTableViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Questions"
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell

        cell.lbl.text = questions[indexPath.row].question

        return cell
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let q = self.questions[indexPath.row]
        
        let s = UIStoryboard(name: "Admin", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "ViewQuestionTableViewController") as! ViewQuestionTableViewController
        
        vc.id = q.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let q  = self.questions[indexPath.row]

            let query = db.child("Answers").queryOrdered(byChild: "QuestionID").queryEqual(toValue: q.id)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
             
                
                if  let val = snapshot.value as? NSDictionary{
                    for key in (val.keyEnumerator()){
                        if  (val.value(forKey: key as! String) as? NSDictionary) != nil{
                           
                            let id = key as! String
                             self.db.child("Answers").child(id).removeValue()
                
                        }}
                    self.tableView.reloadData()
                    
                }
                self.tableView.reloadData()
            }
            )
            db.child("Questions").child(q.id!).removeValue()
        }
    }


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
