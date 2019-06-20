//
//  HelpedSeekersTableViewController.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/14/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class VolunteerHelpedSeekersTableViewController: UITableViewController {
    
    //    var currentVolunteer: String = "LhH2mWFCdPAUvFd0iAn"
    var currentVolunteer: String = ""
    var sessionLogs = [VolunteerSessionLogHistory]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userID = Auth.auth().currentUser?.uid {
            currentVolunteer = userID
        }
        
        loadSessionLogs()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func loadSessionLogs() {
        let ref = Database.database().reference().child("SessionLog")
        let query = ref
        query.observe(.value, with: {(snapshot) in for childSnapshot in snapshot.children {
            print(childSnapshot)
            let childSnap = childSnapshot as! DataSnapshot
            let dict = childSnap.value as! [String: Any]
            let volunteerID = dict["VolunteerID"] as? String ?? "-"
            let ended = dict["Ended"] as? Bool ?? false

            
            
            if self.currentVolunteer == volunteerID && ended == true {
                
                
                let date = dict["Date"] as? String ?? "-"
                let requestedCall = dict["RequestedCall"] as? Bool ?? false
                let seekerId = dict["SeekerID"] as? String ?? "-"
                let seekerName = dict["SeekerName"] as? String ?? "-"
                let seekerRating = dict["SeekerRating"] as? Int ?? 0
                let sessionId = dict["SessionID"] as? String ?? "-"
                let volunteerID = dict["VolunteerID"] as? String ?? "-"
                let volunteerName = dict["VolunteerID"] as? String ?? "-"
                let volunteerRating = dict["VolunteerRating"] as? Int ?? 0

                
                
                
                guard let sessionLog = VolunteerSessionLogHistory(date: date, requestedCall: requestedCall, seekerId: seekerId, seekerName: seekerName, seekerRating: seekerRating, sessionID: sessionId, volunteerID: volunteerID, volunteerName: volunteerName, volunteerRating: volunteerRating, ended: true) else {
                    fatalError("Unable to instantiate this material")
                }
                
                self.sessionLogs += [sessionLog]
            }
            }
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sessionLogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cellIdentifier = "sessionLogViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VolunteerHelpedSeekersTableViewCell else {
            fatalError("The dequeued cell is not an instance of ReadingMaterialTableViewCell.")
        }
        
        let sessionLog = self.sessionLogs[indexPath.row]
        
        cell.seekerName.text = sessionLog.seekerName
        cell.helpHistory.text = sessionLog.date

        
        return cell
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
