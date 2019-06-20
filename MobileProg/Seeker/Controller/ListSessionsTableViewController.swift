//
//  ListSessionsTableViewController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/19/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase



class ListSessionsTableViewController: UITableViewController {
    let db =  Database.database().reference()
    var logs:[SessionLog] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = Auth.auth().currentUser?.uid {
            
            self.db.child("SessionLog").queryOrdered(byChild:"SeekerID").queryEqual(toValue:uid).observeSingleEvent(of: .value, with: {(snapshot) in
                self.logs.removeAll()
                let value = snapshot.value as? NSDictionary
                
                for key in (value?.keyEnumerator())!{
                    let row = value?.value(forKey: key as! String)
                    if  let nonNil = row as? NSDictionary {
                        let id = key as? String
                        let seekerId = nonNil.value(forKey: "SeekerID") as? String
                        let volunteerID = nonNil.value(forKey: "VolunteerID") as? String
                        let date = nonNil.value(forKey: "Date") as? String
                    
                        var log = SessionLog(id: id, helpseeker: nil, helpseekerId: nil, volunteer: nil, volunteerId: nil, requestedCall: nil, helpSeekerRating: nil, volunteerRating: nil, date: date)
                        self.db.child("User").child(volunteerID!).child("Username").observeSingleEvent(of: .value, with: { snapshot in
                            
                            if let sek = snapshot.value as? String{
                                log.volunteer = sek
                                
                            }
                            
                            
                            
                            self.logs.append(log)
                            
                            self.tableView.reloadData()
                        })
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                }
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return logs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        
        cell.textLabel!.text = logs[indexPath.row].volunteer
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
