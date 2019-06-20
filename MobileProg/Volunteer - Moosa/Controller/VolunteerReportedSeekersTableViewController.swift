//
//  ReportedSeekersTableViewController.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/12/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class VolunteerReportedSeekersTableViewController: UITableViewController {
    
    var reportedSeekers = [VolunteerSeeker]()
    var selectedSeeker: VolunteerSeeker?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadReportedSeekers()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func loadReportedSeekers() {
        self.reportedSeekers.removeAll()
        let ref = Database.database().reference().child("User")
        let query = ref
        query.observe(.value, with: {(snapshot) in for childSnapshot in snapshot.children {
            print(childSnapshot)
            let childSnap = childSnapshot as! DataSnapshot
            let dict = childSnap.value as! [String: Any]
            let role = dict["Role"] as? String ?? "-"
            let isReported = dict["IsReported"] as? Bool ?? false

            print(isReported)
            
            
            if role == "Seeker" && isReported == true {
                
                let email = dict["Email"] as? String ?? "-"
                let name = dict["Name"] as? String ?? "-"
                let picturePath = dict["PicturePath"] as? String ?? "-"
                let username = dict["Username"] as? String ?? "-"
                let phoneNumber = dict["PhoneNumber"] as? String ?? "-"
                let requestedVolunteer = dict["RequestedVolunteer"] as? String ?? "-"
                let id = snapshot.key

                
                
                
                guard let seeker = VolunteerSeeker(email: email, isReported: isReported, name: name, picturePath: picturePath, role: role, username: username, phoneNumber: phoneNumber, requestedVolunteer: requestedVolunteer, seekerId: id) else {
                    fatalError("Unable to instantiate this material")
                }
                
                self.reportedSeekers += [seeker]
                
                
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
        return self.reportedSeekers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cellIdentifier = "ReportedSeekerViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VolunteerReportedSeekersTableViewCell else {
            fatalError("The dequeued cell is not an instance of ReadingMaterialTableViewCell.")
        }
        
        let seeker = self.reportedSeekers[indexPath.row]
        
        cell.reportedSeeker.text = seeker.username
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSeeker = self.reportedSeekers[indexPath.row]
        performSegue(withIdentifier: "showReportedDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReportedDetails" {
            if let destinationVC = segue.destination as? VolunteerReportedDetailsTableViewController {
                destinationVC.reportedSeeker = selectedSeeker
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
