//
//  SelectLogFoUserTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/29/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class SelectLogFoUserTableViewController: UITableViewController {

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var filter: UISegmentedControl!
    
        var searchActive = false
        var logs:[Any] = []
        var type = "Login"
        var userID:String?
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
        switch type {
        case "Login":
            
            let query = db.child("LoginLog").queryOrdered(byChild: "UserId").queryEqual(toValue: self.userID!)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                self.logs.removeAll()

                if  let val = snapshot.value as? NSDictionary{
                    for key in (val.keyEnumerator()){
                        if  let row = val.value(forKey: key as! String) as? NSDictionary{
                            
                           let id = key as! String
                            var log = LoginLog(id: id, userId: nil, user: nil, platform: nil, status: nil, date: nil)
                            if let platform = row.value(forKey: "Platform") as? String {
                                log.platform = platform
                            }
                            if let status = row.value(forKey: "Status") as? String {
                                log.status = status
                            }
                            if let date = row.value(forKey: "Date") as? String {
                                log.date = date
                            }

                          
                            self.logs.append(log)
                        }}
                    self.tableView.reloadData()
                    
                }})
            
            
        
     
    
        case "Session":
            

      
            self.db.child("SessionLog").observeSingleEvent(of: .value, with: { (snapshot) in
                self.logs.removeAll()


                let value = snapshot.value as? NSDictionary
                
                for key in (value?.keyEnumerator())!{
                    let row = value?.value(forKey: key as! String)
                    if  let nonNil = row as? NSDictionary {
                        let id = key as! String
                     
                       
                        let date = nonNil.value(forKey: "Date") as? String
                        var seeker = ""
                        var volunteer = ""
                        if let seekerId = nonNil.value(forKey: "SeekerId") as? String{ self.db.child("User").child(seekerId).child("Username").observeSingleEvent(of: .value, with: { snapshot in
                            
                            seeker = snapshot.value as! String
                            
                        })}
                        if  let volunteerId = nonNil.value(forKey: "VolunteerId") as? String{ self.db.child("User").child(volunteerId).child("Username").observeSingleEvent(of: .value, with: { snapshot in
                            
                            volunteer = snapshot.value as! String
                            
                        })}
                        
                        let log = SessionLog(id: id, helpseeker: seeker, helpseekerId: nil, volunteer: volunteer, volunteerId: nil, requestedCall: nil, helpSeekerRating: nil, volunteerRating: nil, date: date)
                        self.logs.append(log)
                        
                        
                        
                        
                    }
                }
                
            })

            
        case "Appointment":
            self.db.child("Appointment").observeSingleEvent(of: .value, with: { (snapshot) in
                self.logs.removeAll()


                let value = snapshot.value as? NSDictionary
                
                for key in (value?.keyEnumerator())!{
                    let row = value?.value(forKey: key as! String)
                    if  let nonNil = row as? NSDictionary {
                        let id = key as! String
                        let date = nonNil.value(forKey: "Date") as? String
                        var seeker = ""
                        var doctor = ""
                        
                        
                        if let seekerId = nonNil.value(forKey: "SeekerId") as? String{ self.db.child("User").child(seekerId).child("Username").observeSingleEvent(of: .value, with: { snapshot in
                            
                            seeker = snapshot.value as! String
                            
                        })}
                       if let DoctorId = nonNil.value(forKey: "DoctorID") as? String
                       {
 self.db.child("User").child(DoctorId).child("Username").observeSingleEvent(of: .value, with: { snapshot in
                            if let doc = snapshot.value as? String{
                                doctor = doc
                            }
                            
 })}
                        
                        let log = AppintmentLog(id: id, seeker: seeker, seekerId: nil, doctor: doctor, doctorId: nil, date: date, seekerRating: nil, doctorRating: nil, descrption: nil)
                        self.logs.append(log)
                        
                        
                        
                        
                    }
                }
                self.tableView.reloadData()
            })

        default:
            print("")
            
        }
        tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
     
          return logs.count
        
        
    }

    @IBAction func filterChanged(_ sender: Any) {
        
        if filter.selectedSegmentIndex == 0 {
            self.type = "Login"
        }else if filter.selectedSegmentIndex == 1 {
           self.type = "Session"
        }else if filter.selectedSegmentIndex == 2{
           self.type = "Appointment"
        }
        self.logs.removeAll()
        loadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        switch type {
        case "Login":
      let log = logs[indexPath.row] as! LoginLog
          
            cell.Title.text =  "\(log.status!) Login"
            cell.Date.text = log.date
            
        case "Session":

            
               let  log = logs[indexPath.row] as! SessionLog

            
            cell.Title.text =  "asked for session with @\(log.volunteer!)"
            cell.Date.text = log.date
        case "Appointment":
         
               let  log = logs[indexPath.row] as! AppintmentLog

            
            
            cell.Title.text =  "asked for Appintment with @\(log.doctor!)"
            cell.Date.text = log.date
        default:
            
            print("error invalid type")       }

        return cell
    }
  
   
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        

        
        
        
     
            searchActive = true;
        
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = UIStoryboard(name: "Admin", bundle: nil)
        switch type {
        case "Login":
   
                let log = logs[indexPath.row] as! LoginLog
            
            let vc  = s.instantiateViewController(withIdentifier: "ShowLoginLogTableViewController") as! ShowLoginLogTableViewController
            vc.id = log.id
            self.navigationController?.pushViewController(vc, animated: true)
        case "Session":
     
                
      
              let  log = logs[indexPath.row] as! SessionLog
                
            
            let vc  = s.instantiateViewController(withIdentifier: "ShowSessionLogTableViewController") as! ShowSessionLogTableViewController
            vc.id = log.id
            self.navigationController?.pushViewController(vc, animated: true)
          
        case "Appointment":
 
                let log = logs[indexPath.row] as! AppintmentLog
                
            
            let vc  = s.instantiateViewController(withIdentifier: "ShowAppointmentLogTableViewController") as! ShowAppointmentLogTableViewController
            vc.id = log.id
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            
            print("error invalid type")       }
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
