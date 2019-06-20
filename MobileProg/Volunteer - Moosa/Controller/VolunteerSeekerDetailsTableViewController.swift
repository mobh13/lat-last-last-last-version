//
//  SeekerDetailsTableViewController.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/12/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import Cosmos


class VolunteerSeekerDetailsTableViewController: UITableViewController {
    
    var selectedSeeker: VolunteerSeeker?
    //    var currentVolunteer: String = "LhH2mWFCdPAUvFd0iAn"
    var currentVolunteer: String = ""
    var currentSessionID: String = ""
    
    
    @IBOutlet weak var seekerProfilePic: UIImageView!
    @IBOutlet weak var seekerUsername: UILabel!
    @IBOutlet weak var seekerPhoneNumber: UITextView!
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var endSessionButton: UIButton!
    
    func sessionStarted() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: date)
        var fullName: String = ""
        var volunteerId: String = ""
        
        
        let ref = Database.database().reference()
        ref.child("User/\(self.currentVolunteer)").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as! [String: Any]
            fullName = dict["Name"] as? String ?? "-"
            volunteerId = dict["Id"] as? String ?? "-"
            
            let db = Database.database().reference().child("SessionLog");
            var key = db.childByAutoId().key
            key = String(key!)
            self.currentSessionID = key!
            let sessionDB = ["Date": formattedDate,
                             "SeekerID": self.selectedSeeker!.seekerId,
                             "SeekerName": self.selectedSeeker!.name,
                             "VolunteerID": volunteerId,
                             "VolunteerName": fullName,
                             "RequestedCall": "",
                             "SeekerRating": "",
                             "VolunteerRating": "",
                             "Ended" : ""
                ] as [String: Any]
            
            db.child(key!).setValue(sessionDB)
            
            db.child(key!).child("Ended").setValue(false)

            
            if self.selectedSeeker?.requestedVolunteer == volunteerId {
                db.child(key!).child("RequestedCall").setValue(true)
            } else {
                db.child(key!).child("RequestedCall").setValue(false)
            }
        })
    }
    
    @IBAction func rateSessionPressed(_ sender: Any) {
        let db = Database.database().reference().child("SessionLog");
//        db.child(self.currentSessionID).child("VolunteerRating").setValue(0)
        db.child(self.currentSessionID).child("SeekerRating").setValue(Int(self.ratingStars.rating))
        
        let alert = UIAlertController(title: "Success", message: "You have successfully rated this session", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    @IBAction func endSessionClicked(_ sender: Any) {
        ratingStars.isHidden = false
        rateButton.isHidden = false
        endSessionButton.isHidden = true
        
        let db = Database.database().reference().child("SessionLog");
        db.child(self.currentSessionID).child("Ended").setValue(true)
        
        
        let alert = UIAlertController(title: "Session Ended", message: "Current Session has been ended, now you can rate the sessionn", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rateButton.isHidden = true
        ratingStars.isHidden = true
        
        if let userID = Auth.auth().currentUser?.uid {
            currentVolunteer = userID
        }
        
        if currentSessionID == "" {
            sessionStarted()
        }

        
        seekerUsername.text = selectedSeeker?.username
        seekerPhoneNumber.text = String(selectedSeeker!.phoneNumber)
        
        getImage()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        seekerPhoneNumber.dataDetectorTypes = .phoneNumber
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.navigationItem.title = "Seeker Details";
    }
    
    
    @IBAction func clickReportButton(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Notice", message: "Are you sure you want to report this user?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //Do something
            self.reportSeeker()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //Do nothing
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func getImage() {
        let ref = Database.database().reference()
        ref.child("User/\(selectedSeeker!.seekerId)").observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String: Any]
            let path = dict["PicturePath"] as? String ?? "profilepic.png"
            let storageRef = Storage.storage().reference().child(path)
            storageRef.downloadURL {
                url, error in guard let url = url else { return }
                self.seekerProfilePic.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: nil)
            }
        })
    }
    
    
    func reportSeeker() {
        
        let alert = UIAlertController(title: "What happened?", message: "Enter your reasoning for reportation here", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Reason for reportation here..."
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let textField = alert.textFields![0]
            print("Text field: \(textField.text ?? "-")")
            
            let ref = Database.database().reference()
        
            ref.child("User").child(self.selectedSeeker!.seekerId).child("IsReported").setValue(true)
               self.reportUser(reasonForReport: textField.text ?? "-", user: self.selectedSeeker!.seekerId)

            
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
    func reportUser(reasonForReport: String, user: String) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let formattedDate = dateFormatter.string(from: date)
        let db = Database.database().reference().child("Report");
        let key = db.childByAutoId().key
        let reportDB = ["By": self.currentVolunteer,
                        "Date": formattedDate,
                        "Reason": reasonForReport,
                        "User": user,
        ]
        
        db.child(key!).setValue(reportDB)
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
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
