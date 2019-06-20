//
//  QuizQuestionsTableViewController.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/11/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class VolunteerQuizQuestionsTableViewController: UITableViewController {
    
    var quizQuestions = [VolunteerQuizQuestion]()
    var presentedQuizQuestions = [VolunteerQuizQuestion]()
    var quizAnswers = [VolunteerQuizAnswer]()
    var userImage: UIImageView?
    
    
    var currentVolunteer = VolunteerVolunteer(username: "", email: "", password: "", fullName: "", phoneNumber: "", CPRNumber: "", DOB: "", picturePath: "")
    


    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestions()
        
        
        let alert = UIAlertController(title: "Attention", message: "You should complete this quiz to be qualified to help seekers", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Understood", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    
    
    func loadQuestions() {
        //        self.materials.removeAll()
        let ref = Database.database().reference().child("Questions")
//        let query = ref.queryOrdered(byChild: "id")
        ref.observe(.value, with: {(snapshot) in for childSnapshot in snapshot.children {
            print(childSnapshot)
            let childSnap = childSnapshot as! DataSnapshot
            let key = childSnap.key
            let dict = childSnap.value as! [String: Any]
            let question = dict["Question"] as! String
            let type = dict["Type"] as? String
//            let type = dict["Type"] as! String
            
            if type == "Quiz" {
                guard let quizQuestion = VolunteerQuizQuestion(question: question, type: type!, key: key) else {
                fatalError("Unable to instantiate this quiz question")
            }
                
            self.loadAnswers(questionKey: key)
                
            self.quizQuestions += [quizQuestion]
                
            self.quizQuestions.shuffle()
                if self.quizQuestions.count >= 5 {
            self.presentedQuizQuestions = Array(self.quizQuestions[0..<5])
                }
                
            }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func loadAnswers(questionKey: String) {
        let ref = Database.database().reference()
        ref.child("Answers").observe(.value, with: {(snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let answerID = child.key as String //get autoID
                    ref.child("Answers/\(answerID)/QuestionID").observe(.value, with: { (snapshot) in
                        if let questionID = snapshot.value as? String {
                            //change this ID and put current uid
                            
                            if questionID == questionKey {
                                print(questionID)
                                print(questionKey)
                                let dict = child.value as! [String: Any]
                                let answer = dict["Answer"] as? String ?? "a"
                                let correct = dict["Correct"] as? String ?? "b"
                                let questionID = dict["QuestionID"] as? String ?? "c"
                                guard let quizAnswer = VolunteerQuizAnswer(answer: answer, correct: correct, questionID: questionID) else {
                                    fatalError("Unable to instantiate this quiz question")
                                }
                                
                                self.quizAnswers += [quizAnswer]
                                self.tableView.reloadData()

                                

                            }
                        }
                    })
                }
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
        return self.presentedQuizQuestions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "quizQuestionTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VolunteerQuizQuestionTableViewCell else {
            fatalError("The dequeued cell is not an instance of ReadingMaterialTableViewCell.")
        }
        
        let question = self.presentedQuizQuestions[indexPath.row]
        
        cell.questionLabel.text = question.question
        
        var i = 0
        for quizAnswer in quizAnswers {
            if quizAnswer.questionID == question.key {
                    cell.answerButtons[i].setTitle(quizAnswer.answer, for: .normal)
                i += 1
            }
            
        }
        
        print(quizAnswers.count)

        
                
        return cell
    }
    
    
    @IBAction func registerClicked(_ sender: Any) {
        let totalSection = tableView.numberOfSections
        var allQuestions = 0
        var score = 0
        for section in 0..<totalSection
        {
            print("section \(section)")
            let totalRows = tableView.numberOfRows(inSection: section)
            
            for row in 0..<totalRows
            {
                print("row \(row)")
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? VolunteerQuizQuestionTableViewCell
                
                print(cell?.questionLabel.text ?? "h")
                
                for answerButton in cell!.answerButtons {
                            for quizAnswer in quizAnswers {
                                if answerButton.isEnabled == false && answerButton.titleLabel!.text == quizAnswer.answer {
                                    if quizAnswer.correct == "true" {
                                        score += 1
                                        print(score)
                                    }
                                }
                            }
                        }

            allQuestions = totalRows
        }
        }
        
        
        
        
//        print("score is", (Float(score)/Float(allQuestions)))
        if (Float(score)/Float(allQuestions)) >= 0.5 {
            registerVolunteer()
            let alert = UIAlertController(title: "Congratulations", message: "You have made it in the quiz", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {_ in
                self.performSegue(withIdentifier: "showApp", sender: nil)}))
            self.present(alert, animated: true, completion: nil)
        
        } else {
            let alert = UIAlertController(title: "Sorry", message: "These answers don't qualify you to be a volunteer", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK, I'll try again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    func registerVolunteer() {
        let db = Database.database().reference().child("User");
        let key = Auth.auth().currentUser?.uid
        let volunteerDB = ["Id": key!,
                           "CPR": currentVolunteer?.CPRNumber,
                           "DOB": currentVolunteer?.DOB,
                           "Email": currentVolunteer?.email,
                           "Name": currentVolunteer?.fullName,
                           "Password": currentVolunteer?.password,
                           "PhoneNumber": currentVolunteer?.phoneNumber,
                           "Username": currentVolunteer?.username,
                           "Role": "Volunteer",
                           "PicturePath": currentVolunteer?.picturePath,
                           "IsBlocked": "",
                           "IsReported": ""
        ]
        
        db.child(key!).setValue(volunteerDB)
        
        db.child(key!).child("IsBlocked").setValue(false)
        
        db.child(key!).child("IsReported").setValue(false)
        
        if currentVolunteer?.picturePath != "profilepic.png" {
        self.uploadPicture(ref: db, key: key!)
        }
    }
    
    func uploadPicture(ref: DatabaseReference, key: String) {
        let storRef = Storage.storage().reference().child(currentVolunteer!.picturePath)
        _ = storRef.putData(self.userImage!.image!.pngData()!, metadata: nil) { (metadata, error) in
            if error != nil {
                let alert = UIAlertController(title: "Picture Error!", message: "Default picture has been set. "+error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                self.present(alert, animated: true)
                ref.child("User/\(key)").child("PicturePath").setValue("profilepic.png")
                return
            }else{
                ref.child("User/\(key)").child("PicturePath").setValue(key)
            }
        }
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
