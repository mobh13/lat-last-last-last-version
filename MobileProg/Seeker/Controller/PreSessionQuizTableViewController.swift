//
//  PreSessionQuizTableViewController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/17/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//
import UIKit
import Firebase

class PreSessionQuizTableViewController: UITableViewController {

    @IBOutlet weak var txtQuestion: UILabel!
    @IBOutlet weak var Btn1: UIButton!
    @IBOutlet weak var Btn2: UIButton!
    @IBOutlet weak var Btn3: UIButton!
    @IBOutlet weak var Btn4: UIButton!
    @IBOutlet weak var Btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
   
    @IBAction func btnResultClicked(_ sender: Any) {
        var counter:Float = 0
        for cell in tableView.visibleCells {
            let c = cell as! QuestionTableViewCell
            counter = counter + c.slider.value
        }
        
        let s = UIStoryboard(name: "Seeker", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        vc.result = counter
        navigationController?.pushViewController(vc, animated: true)

            
    }
    
    var questions: [PresessionQuizData] = []
//        PresessionQuizData(text: "Little interest or pleasure in doing things",
//                 answers: [
//                    Answer(text:"Not at all",answerpoint: 0),
//                    Answer(text:"rarely",answerpoint: 1),
//                    Answer(text:"Sometimes",answerpoint: 2),
//                    Answer(text:"often",answerpoint: 3),
//                    Answer(text:"always",answerpoint: 4)]),
//        PresessionQuizData(text: "Feeling down ,depressed, or hopless",
//                           answers: [
//                            Answer(text:"Not at all",answerpoint: 0),
//                            Answer(text:"rarely",answerpoint: 1),
//                            Answer(text:"Sometimes",answerpoint: 2),
//                            Answer(text:"often",answerpoint: 3),
//                            Answer(text:"always",answerpoint: 4)]),
//        PresessionQuizData(text: "Trouble falling or staying asleep ,or sleeping too much ",
//                           answers: [
//                            Answer(text:"Not at all",answerpoint: 0),
//                            Answer(text:"rarely",answerpoint: 1),
//                            Answer(text:"Sometimes",answerpoint: 2),
//                            Answer(text:"often",answerpoint: 3),
//                            Answer(text:"always",answerpoint: 4)]),
//        PresessionQuizData(text: "feeling tired or having little energy",
//                           answers: [
//                            Answer(text:"Not at all",answerpoint: 0),
//                            Answer(text:"rarely",answerpoint: 1),
//                            Answer(text:"Sometimes",answerpoint: 2),
//                            Answer(text:"often",answerpoint: 3),
//                            Answer(text:"always",answerpoint: 4)]),
//        PresessionQuizData(text: "Poor appetite or overeating",
//                           answers: [
//                            Answer(text:"Not at all",answerpoint: 0),
//                            Answer(text:"rarely",answerpoint: 1),
//                            Answer(text:"Sometimes",answerpoint: 2),
//                            Answer(text:"often",answerpoint: 3),
//                            Answer(text:"always",answerpoint: 4)]),
//        PresessionQuizData(text: "Moving oe speaking so slowly or the opposite so figety and moving around a lot more than usual",
//        answers: [
//        Answer(text:"Not at all",answerpoint: 0),
//        Answer(text:"rarely",answerpoint: 1),
//        Answer(text:"Sometimes",answerpoint: 2),
//        Answer(text:"often",answerpoint: 3),
//        Answer(text:"always",answerpoint: 4)]),
//        PresessionQuizData(text: "thoughts that you would be better off dead, or of hurting yourself  ",
//                           answers: [
//                            Answer(text:"Not at all",answerpoint: 0),
//                            Answer(text:"rarely",answerpoint: 1),
//                            Answer(text:"Sometimes",answerpoint: 2),
//                            Answer(text:"often",answerpoint: 3),
//                            Answer(text:"always",answerpoint: 4)]),
//        PresessionQuizData(text: "In the last month, how often have you been upset because of something that happened unexpectedly?",
//                           answers: [
//                            Answer(text:"Not at all",answerpoint: 0),
//                            Answer(text:"rarely",answerpoint: 1),
//                            Answer(text:"Sometimes",answerpoint: 2),
//                            Answer(text:"often",answerpoint: 3),
//                            Answer(text:"always",answerpoint: 4)]),
//        PresessionQuizData(text: "In the last month, how often have you felt that you were unable tocontrol the important things in your life?" ,
//                           answers: [
//                            Answer(text:"Not at all",answerpoint: 0),
//                            Answer(text:"rarely",answerpoint: 1),
//                            Answer(text:"Sometimes",answerpoint: 2),
//                            Answer(text:"often",answerpoint: 3),
//                            Answer(text:"always",answerpoint: 4)]),
//        PresessionQuizData(text: "In the last month, how often have you felt nervous and “stressed”?",
//                           answers: [
//                            Answer(text:"Not at all",answerpoint: 0),
//                            Answer(text:"rarely",answerpoint: 1),
//                            Answer(text:"Sometimes",answerpoint: 2),
//                            Answer(text:"often",answerpoint: 3),
//                            Answer(text:"always",answerpoint: 4)]),
//        PresessionQuizData(text: " In the last month, how often have you felt confident about your ability to handle your personal problems?",
//        answers: [
//        Answer(text:"Not at all",answerpoint: 0),
//        Answer(text:"rarely",answerpoint: 1),
//        Answer(text:"Sometimes",answerpoint: 2),
//        Answer(text:"often",answerpoint: 3),
//        Answer(text:"always",answerpoint: 4)])
//
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = " Survey "
        Database.database().reference().child("Questions").queryOrdered(byChild: "Type").queryEqual(toValue: "Survey").observeSingleEvent(of: .value, with: {(snapshot) in
            if let snap = snapshot.value as? NSDictionary {
                
                for key in snap.allKeys{
                    
                    if let row = snap.value(forKey: key as! String) as? NSDictionary{
                        
                        if let text = row.value(forKey: "Question") as? String{
                            
                          let q = PresessionQuizData(text: text)
                            self.questions.append(q)
                        }
                    }
                }
                self.questions = self.questions.shuffled()
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if questions.count > 5 {
            return 5
            
        }else{
            return questions.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        let q = questions[indexPath.row]
        cell.lbl.text = q.text
        
        

        // Configure the cell...

        return cell
    }

    //let s = UIStoryboard(name: "Seeker", bundle: nil)
    //let vc = s.instantiateViewController(withIdentifier: "") as! SeekerEditProfileController
    //vc.self.
    //self.navigationController?.pushViewController(vc, animated: true)
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

    

