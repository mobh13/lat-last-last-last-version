//
//  HomeTableViewController.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/9/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class VolunteerHomeTableViewController: UITableViewController {
    
    var seekers = [VolunteerSeeker]()
    var sessions = [VolunteerSessionLogHistory]()

    var selectedSeeker: VolunteerSeeker?
    var selectedSession: VolunteerSessionLogHistory?

//    var currentVolunteer: String = "LhH2mWFCdPAUvFd0iAn"
    var currentVolunteer: String = ""
    
    


    override func viewDidLoad() {
        self.tableView.reloadData()

        if let userID = Auth.auth().currentUser?.uid {
            currentVolunteer = userID
        }

        
//        loadAllOpenedSessions()
        loadAllSeekers()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAllOpenedSessions()
        self.tabBarController?.navigationItem.hidesBackButton = true;
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.navigationItem.title = "Home Page"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor( red: CGFloat(145/255.0), green: CGFloat(189/255.0), blue: CGFloat(222/255.0), alpha: CGFloat(1.0))
    }
    
    private func loadAllSeekers() {
        self.seekers.removeAll()
        let ref = Database.database().reference().child("User")
        let query = ref
        query.observe(.value, with: {(snapshot) in for childSnapshot in snapshot.children {
            print(childSnapshot)
            let childSnap = childSnapshot as! DataSnapshot
            let dict = childSnap.value as! [String: Any]
            let role = dict["Role"] as? String ?? "-"

            
            
            if role == "Seeker" {
            
                
                let email = dict["Email"] as? String ?? "-"
                let isReported = dict["IsReported"] as? Bool ?? false
                let name = dict["Name"] as? String ?? "-"
                let picturePath = dict["PicturePath"] as? String ?? "-"
                let username = dict["Username"] as? String ?? "-"
                let phoneNumber = dict["PhoneNumber"] as? String ?? "-"
                let requestedVolunteer = dict["RequestedVolunteer"] as? String ?? "-"
                let id = String(childSnap.key)

                
                
                
                guard let seeker = Seeker(email: email, isReported: isReported, name: name, picturePath: picturePath, role: role, username: username, phoneNumber: phoneNumber, requestedVolunteer: requestedVolunteer, seekerId: id) else {
                    fatalError("Unable to instantiate this material")
                
            }
            self.seekers += [seeker]
            }

            }
//            self.tableView.reloadData()
        })
    }
    
    private func loadAllOpenedSessions() {
        self.sessions.removeAll()
        let ref = Database.database().reference().child("SessionLog")
        let query = ref
        query.observeSingleEvent(of: .value, with: {(snapshot) in for childSnapshot in snapshot.children {
            print(childSnapshot)
            let childSnap = childSnapshot as! DataSnapshot
            let id = String(childSnap.key)
            let dict = childSnap.value as! [String: Any]
            let date = dict["Date"] as? String ?? "-"
            let ended = dict["Ended"] as? Bool ?? true
            let requestedCall = dict["RequestedCall"] as? Bool ?? true
            let seekerId = dict["SeekerID"] as? String ?? "-"
            let seekerName = dict["SeekerName"] as? String ?? "-"
            let seekerRating = dict["SeekerRating"] as? Int ?? 0
            let volunteerId = dict["VolunteerID"] as? String ?? "-"
            let volunteerName = dict["VolunteerName"] as? String ?? "-"
            let volunteerRating = dict["VolunteerRating"] as? Int ?? 0


            
            
            
            if ended == false && self.currentVolunteer == volunteerId {
                
                
                
                guard let session = SessionLogHistory(date: date, requestedCall: requestedCall, seekerId: seekerId, seekerName: seekerName, seekerRating: seekerRating, sessionID: id, volunteerID: volunteerId, volunteerName: volunteerName, volunteerRating: volunteerRating, ended: ended) else {
                    fatalError("Unable to instantiate this material")
                }
                
                self.sessions += [session]
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
        return self.sessions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cellIdentifier = "RequestedSeeekerViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RequestedSeekerTableViewCell else {
            fatalError("The dequeued cell is not an instance of ReadingMaterialTableViewCell.")
        }
        
//        let session = self.sessions[indexPath.row]
        
        var rowSeeker: Seeker?
        for seeker in seekers {
            if seeker.seekerId == sessions[indexPath.row].seekerId {
                rowSeeker = seeker
            }
        }
        
        cell.requestedSeekerLabel.text = rowSeeker?.username
        
        return cell
    }
    
    func getSelectedSeeker() {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for seeker in seekers {
            if seeker.seekerId == sessions[indexPath.row].seekerId {
                self.selectedSeeker = seeker
            }
        }
        
        self.selectedSession = sessions[indexPath.row]
        
        let refreshAlert = UIAlertController(title: "Continue Session", message: "Are you sure you want to continue a previous session with " + selectedSeeker!.username + "?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { (action: UIAlertAction!) in
            //Do something
            self.performSegue(withIdentifier: "showSeekerDetails", sender: nil)

        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //Do nothing
        }))
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSeekerDetails" {
            if let destinationVC = segue.destination as? SeekerDetailsTableViewController {
                destinationVC.selectedSeeker = selectedSeeker
                destinationVC.currentSessionID = selectedSession!.sessionID
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionName: String
        switch section {
        case 0:
            sectionName = NSLocalizedString("All Your Opened Sessions", comment: "All Your Opened Sessions")
        default:
            sectionName = ""
        }
        return sectionName
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
