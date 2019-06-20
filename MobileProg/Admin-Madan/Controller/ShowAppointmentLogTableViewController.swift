//
//  ShowAppointmentLogTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/30/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
class ShowAppointmentLogTableViewController: UITableViewController {
    
    
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var helpSeekerLbl: UILabel!
    @IBOutlet weak var doctorRating: CosmosView!
    @IBOutlet weak var appointmentNoteText: UITextView!
    @IBOutlet weak var helpSeekerRating: CosmosView!
    @IBOutlet weak var doctorLbl: UILabel!
    
    
    var id:String?
    let db =  Database.database().reference()
    var log = AppintmentLog(id: nil, seeker: nil, seekerId: nil, doctor: nil, doctorId: nil, date: nil, seekerRating: nil, doctorRating: nil, descrption: nil)
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

    func loadData(){
        self.db.child("Appointment").child(id!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
       
            if let  date = value?.value(forKey: "Date") as? String{
                
                self.datelbl.text = date

            }
            if let  time = value?.value(forKey: "Time") as? String{
                
                self.datelbl.text?.append(" \(time)")
                
            }
            if let  sRate = value?.value(forKey: "SeekerRate") as? Double{
                
                self.helpSeekerRating.rating = sRate
            }
            if let  dRate = value?.value(forKey: "DoctorRate") as? Double{
                
                self.doctorRating.rating = dRate
            }
            if let  note = value?.value(forKey: "Description") as? String{
                
                self.appointmentNoteText.text = note

            }
            
            if let seekerId = value?.value(forKey: "SeekerID") as? String{
                
                self.log.seekerId = seekerId
                self.db.child("User").child(seekerId).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    
                    if let  username = value?.value(forKey: "Username") as? String{
                        
                        self.helpSeekerLbl.text = username

                    }
                    
                })
            }
            if let doctorID = value?.value(forKey: "DoctorID") as? String{
                
                self.log.doctorId = doctorID
                self.db.child("User").child(doctorID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    
                    if let  username = value?.value(forKey: "Username") as? String{
                        
                       self.doctorLbl.text = username
                        
                    }
                    
                })
            }
            
        })
       
        
   
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row  == 1 {
            
            
        } else if indexPath.row == 2 {
            
            
        }
    }
    // MARK: - Table view data source

   

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
