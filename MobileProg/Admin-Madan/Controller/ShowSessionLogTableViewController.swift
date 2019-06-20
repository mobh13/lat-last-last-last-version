//
//  ShowSessionLogTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/30/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Cosmos
import Firebase

class ShowSessionLogTableViewController: UITableViewController {

    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var helpSeekerLbl: UILabel!
    @IBOutlet weak var volunteerLbl: UILabel!
    @IBOutlet weak var requestedLbl: UILabel!
    @IBOutlet weak var helpSeekerRating: CosmosView!
    @IBOutlet weak var volunteerRating: CosmosView!
    
    var id:String?
    var log:SessionLog = SessionLog(id: nil, helpseeker: nil, helpseekerId: nil, volunteer: nil, volunteerId: nil, requestedCall: nil
        , helpSeekerRating: nil, volunteerRating: nil, date: nil)
    let db =  Database.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        loadData()
    }
    // MARK: - Table view data source

    func loadData(){
        self.db.child("SessionLog").child(id!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            if let  date = value?.value(forKey: "Date") as? String{
                
                self.dateLbl.text = date
                
            }
         
            if let  sRate = value?.value(forKey: "SeekerRate") as? Double{
                
                self.helpSeekerRating.rating = sRate
            }
            if let  dRate = value?.value(forKey: "DoctorRate") as? Double{
                
                self.volunteerRating.rating = dRate
            }
            if let  reqCall = value?.value(forKey: "RequestedCall") as? Bool{
                
                if reqCall {
                    self.requestedLbl.text = "Yes"
                }else{
                    self.requestedLbl.text = "No"

                }
                
            }
            
            if let seekerId = value?.value(forKey: "SeekerID") as? String{
                
                self.log.helpseekerId = seekerId
                self.db.child("User").child(seekerId).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    
                    if let  username = value?.value(forKey: "Username") as? String{
                        
                        self.helpSeekerLbl.text = username
                        
                    }
                    
                })
            }
            if let volunteerId = value?.value(forKey: "VolunteerID") as? String{
                
                self.log.volunteerId = volunteerId
                self.db.child("User").child(volunteerId).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    
                    if let  username = value?.value(forKey: "Username") as? String{
                        
                        self.volunteerLbl.text = username
                        
                    }
                    
                })
            }
            
        })

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
