//
//  ListLogsTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/24/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class ListLogsTableViewController: UITableViewController, UISearchResultsUpdating {

    var logs:[Any] = []
    var filterd = [Any]()
    var type:String?
    var resultSearchController = UISearchController()

    let db =  Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    func updateSearchResults(for searchController: UISearchController) {
        
        filterd.removeAll(keepingCapacity: false)
        var array = [Any]()
        switch type {
        case "Login":
             array = logs.filter({
                if let i = $0 as? LoginLog{
                    if (i.user!.containsIgnoringCase(find: searchController.searchBar.text!)){
                        return true
                    }else{
                        return false
                    }
                }else{
                   return false
                }
            })
        case "Session":
            array = logs.filter({
                if let i = $0 as? SessionLog{
                    if (i.helpseeker!.containsIgnoringCase(find: searchController.searchBar.text!) || i.volunteer!.containsIgnoringCase(find: searchController.searchBar.text!)){
                        return true
                    }else{
                        return false
                    }
                }else{
                    return false
                }
            })
        case "Appointment":
            array = logs.filter({
                if let i = $0 as? AppintmentLog{
                    if (i.doctor!.containsIgnoringCase(find: searchController.searchBar.text!) || i.seeker!.containsIgnoringCase(find: searchController.searchBar.text!)){
                        return true
                    }else{
                        return false
                    }
                }else{
                    return false
                }
            })
        default:
                print("invalid type")
        }
        filterd = array
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
        
        loadData()
    }

    func loadData(){
        self.logs.removeAll()
        switch type! {
        case "Login":
           self.db.child("LoginLog").observe(.value, with: { (snapshot) in
            self.logs.removeAll()

            let value = snapshot.value as? NSDictionary

            for key in (value?.keyEnumerator())!{
                                            let row = value?.value(forKey: key as! String)
                                            if  let nonNil = row as? NSDictionary {
                                                let id = key as? String
                                                let userid = nonNil.value(forKey: "UserId") as? String
                                                let status = nonNil.value(forKey: "Status") as? String
                                                let platform = nonNil.value(forKey: "Platform") as? String
                                                let date = nonNil.value(forKey: "Date") as? String
                                                Database.database().reference().child("User").child(userid!).child("Username").observe(.value, with: {
                                                    (nameSnapshot) in
                                                    
                                                    let username = nameSnapshot.value as? String
                                                    let log = LoginLog(id: id, userId: userid, user: username, platform: platform, status: status, date: date)
                                                    self.logs.append(log)
                                                    self.tableView.reloadData()
                                                    
                                                })
                                              
                                                
                                               
                                                
                                             
                                               
                }
            }
            DispatchQueue.main.async {
                 self.tableView.reloadData()
            }
            })
           DispatchQueue.main.async {
            self.tableView.reloadData()
            }
            
        case "Session":
            
            
            self.db.child("SessionLog").observeSingleEvent(of: .value, with: { (snapshot) in
                self.logs.removeAll()

                let value = snapshot.value as? NSDictionary
                
                for key in (value?.keyEnumerator())!{
                    let row = value?.value(forKey: key as! String)
                    if  let nonNil = row as? NSDictionary {
                        let id = key as? String
                        let seekerId = nonNil.value(forKey: "SeekerID") as? String
                        let volunteerId = nonNil.value(forKey: "VolunteerID") as? String
                        let date = nonNil.value(forKey: "Date") as? String
                        var seeker = Optional("")
                        var volunteer = Optional("")
                         var log = SessionLog(id: id, helpseeker: seeker, helpseekerId: nil, volunteer: volunteer, volunteerId: nil, requestedCall: nil, helpSeekerRating: nil, volunteerRating: nil, date: date)
                        self.db.child("User").child(seekerId!).child("Username").observeSingleEvent(of: .value, with: { snapshot in
                            
                            if let sek = snapshot.value as? String{
                                log.helpseeker = sek
                                
                            }
                            self.db.child("User").child(volunteerId!).child("Username").observeSingleEvent(of: .value, with: { snapshot in
                                if let vol = snapshot.value as? String{
                                    log.volunteer = vol
                                }
                                
                                
                                self.logs.append(log)
                                
                                self.tableView.reloadData()
                            })
                            
                        })
                      
                        
                        
                        
                        
                        
                    }
                }
             self.tableView.reloadData()
            })
        case "Appointment":
            self.db.child("Appointment").observeSingleEvent(of: .value, with: { (snapshot) in
                self.logs.removeAll()

                let value = snapshot.value as? NSDictionary
                
                for key in (value?.keyEnumerator())!{
                    let row = value?.value(forKey: key as! String)
                    if  let nonNil = row as? NSDictionary {
                        let id = key as? String
                        let seekerId = nonNil.value(forKey: "SeekerID") as? String
                        let DoctorId = nonNil.value(forKey: "DoctorID") as? String
                        let date = nonNil.value(forKey: "Date") as? String
                        var seeker = ""
                        var doctor = ""
                          var log = AppintmentLog(id: id, seeker: seeker, seekerId: nil, doctor: doctor, doctorId: nil, date: date, seekerRating: nil, doctorRating: nil, descrption: nil)
                        self.db.child("User").child(seekerId!).child("Username").observeSingleEvent(of: .value, with: { snapshot in
                            if let sek = snapshot.value as? String{
                                log.seeker = sek
                                
                            }
                            self.db.child("User").child(DoctorId!).child("Username").observeSingleEvent(of: .value, with: { snapshot in
                                if let doc = snapshot.value as? String{
                                   log.doctor = doc
                                }
                                
                                    self.logs.append(log)
                                    self.tableView.reloadData()
                            })
                        })
                   

                      
                    
                        
                        
                        
                        
                    }
                }
            
            })

       
        default:
            print("")
            
        }
   
            self.tableView.reloadData()
        
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if  (resultSearchController.isActive) {
            return filterd.count
        } else {
            return logs.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        if (resultSearchController.isActive) {
            switch type! {
            case "Login":
                let log = filterd[indexPath.row] as! LoginLog
                
                cell.Title.text =  "@\(log.user!) \(log.status!) Login"
                cell.Date.text = log.date
            case "Session":
                let log = filterd[indexPath.row] as! SessionLog
                
                cell.Title.text =  "@\(log.helpseeker!) asked for session with @\(log.volunteer!)"
                cell.Date.text = log.date
            case "Appointment":
                let log = filterd[indexPath.row] as! AppintmentLog
                
                cell.Title.text =  "@\(log.seeker!) asked for Appintment with @\(log.doctor!)"
                cell.Date.text = log.date
            default:
                
                print("error")
                
            }
        }else {
            switch type! {
            case "Login":
                let log = logs[indexPath.row] as! LoginLog
                
                cell.Title.text =  "@\(log.user!) \(log.status!) Login"
                cell.Date.text = log.date
            case "Session":
                let log = logs[indexPath.row] as! SessionLog
                
                cell.Title.text =  "@\(log.helpseeker!) asked for session with @\(log.volunteer!)"
                cell.Date.text = log.date
            case "Appointment":
                let log = logs[indexPath.row] as! AppintmentLog
                
                cell.Title.text =  "@\(log.seeker!) asked for Appintment with @\(log.doctor!)"
                cell.Date.text = log.date
            default:
                
                print("error")
                
            }
        }
       
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let s = UIStoryboard(name: "Admin", bundle: nil)
        switch type! {
        case "Login":
            var log : LoginLog
            if resultSearchController.isActive{
                log = filterd[indexPath.row] as! LoginLog
            }else{
                log = logs[indexPath.row] as! LoginLog
            }
            let vc = s.instantiateViewController(withIdentifier: "ShowLoginLogTableViewController") as! ShowLoginLogTableViewController
            vc.id = log.id
           self.navigationController?.pushViewController(vc, animated: true)
        case "Session":
            var log : SessionLog
            if resultSearchController.isActive{
                log = filterd[indexPath.row] as! SessionLog
            }else{
                 log = logs[indexPath.row] as! SessionLog
            }
            let vc = s.instantiateViewController(withIdentifier: "ShowSessionLogTableViewController") as! ShowSessionLogTableViewController
            vc.id = log.id
            self.navigationController?.pushViewController(vc, animated: true)
        case "Appointment":
            var log : AppintmentLog
            if resultSearchController.isActive{
                  log = filterd[indexPath.row] as! AppintmentLog
            }else{
                  log = logs[indexPath.row] as! AppintmentLog
            }
            let vc = s.instantiateViewController(withIdentifier: "ShowAppointmentLogTableViewController") as! ShowAppointmentLogTableViewController
            vc.id = log.id
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("error unknow type !!")
        }
    }
}
