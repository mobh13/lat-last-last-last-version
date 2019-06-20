//
//  StartSessionTableViewController.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/20/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class StartSessionTableViewController: UITableViewController {
    
    
    @IBOutlet weak var volunteerIdLabel: UILabel!
    @IBOutlet weak var seekerIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var requestCallButton: UIButton!
    @IBOutlet weak var endSessionButton: UIButton!
    @IBOutlet weak var ratingStars: CosmosView!
    
    
    var selectedVolunteer: String = "-LhH2mWFCdPAUvFd0iAn"
    var currentSessionID: String = ""
    var currentSeeker: String = "iJrG8oeg7Ie9IuPRrAxBjwJuRg32"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingStars.isHidden = true
        sessionStarted()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func sessionStarted() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = dateFormatter.string(from: date)
        var fullName: String = ""
        var seekerId: String = ""
        
        var volunteerName: String = ""
        var volunteerId: String = ""
        
        dateLabel.text = formattedDate
        
        var ref = Database.database().reference()
        ref.child("User/\(self.selectedVolunteer)").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as! [String: Any]
            volunteerName = dict["Name"] as? String ?? "-"
            volunteerId = dict["Id"] as? String ?? "-"
        })
        
        
        ref = Database.database().reference()
        ref.child("User/\(self.currentSeeker)").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as! [String: Any]
            fullName = dict["name"] as? String ?? "-"
            seekerId = dict["seekerID"] as? String ?? "-"
            
            let db = Database.database().reference().child("SessionLog");
            var key = db.childByAutoId().key
            key = String(key!)
            self.currentSessionID = key!
            let sessionDB = ["Date": formattedDate,
                             "SeekerID": seekerId,
                             "SeekerName": fullName,
                             "VolunteerID": volunteerId,
                             "VolunteerName": volunteerName,
                             "RequestedCall": "",
                             "SeekerRating": "",
                             "VolunteerRating": "",
                             "Ended" : ""
                ] as [String: Any]
            
            db.child(key!).setValue(sessionDB)
            
            db.child(key!).child("Ended").setValue(false)
            
            self.seekerIdLabel.text = seekerId
            self.volunteerIdLabel.text = volunteerId
            
//            if self.selectedSeeker?.requestedVolunteer == volunteerId {
//                db.child(key!).child("RequestedCall").setValue(true)
//            } else {
//                db.child(key!).child("RequestedCall").setValue(false)
//            }
        })
    }
    
    
    
    @IBAction func requestCallClicked(_ sender: Any) {
        let db = Database.database().reference().child("SessionLog");
       db.child(self.currentSessionID).child("RequestedCall").setValue(true)
        
        requestCallButton.isHidden = true

        let alert = UIAlertController(title: "Success", message: "You have successfully requested a call", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func endSessionClicked(_ sender: Any) {
        endSessionButton.isHidden = true
        ratingStars.isHidden = false
        let db = Database.database().reference().child("SessionLog")
        db.child(self.currentSessionID).child("Ended").setValue(true)
        
        let alert = UIAlertController(title: "Success", message: "You have successfully rated the call", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    @IBAction func submitClicked(_ sender: Any) {
        let db = Database.database().reference().child("SessionLog");
       db.child(self.currentSessionID).child("VolunteerRating").setValue(Int(self.ratingStars.rating))
        let alert = UIAlertController(title: "Success", message: "You have successfully rated the session", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
