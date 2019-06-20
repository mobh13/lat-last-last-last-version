//
//  AppointmentsListTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/20/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class AppointmentsListTableViewController: UITableViewController {
    var appointments = [SeekerAppointment]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("Appointment")
        ref.queryOrdered(byChild: "SeekerID").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                let value = child.value as! NSDictionary
                let app = SeekerAppointment()
               app.id = child.key
                if let date  = value.value(forKey: "Date") as? String {
                    app.Date = date
                }
                if let time  = value.value(forKey: "Time") as? String {
                    app.Time = time
                }
                if let docID  = value.value(forKey: "DoctorID") as? String {
                    app.DoctorID = docID
                }
                if let rate  = value.value(forKey: "DoctorRate") as? Int {
                    app.DoctorRate = rate
                }
                self.appointments.append(app)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appointments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentsListDetail", for: indexPath) as! AppointmentsListTableViewCell
        
        let ref = Database.database().reference().child("User")
        ref.child("\(self.appointments[indexPath.row].DoctorID!)/Name").observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                cell.lblDoc.text = name
            }else{
                cell.lblDoc.text = "Invalid Name"
            }
        })
        cell.lblDate.text = "\(self.appointments[indexPath.row].Date ?? "Invalid Date")"
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = UIStoryboard(name: "Seeker", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "appointmentDetail") as! AppointmentDetailsTableViewController
        vc.appID = self.appointments[indexPath.row].id!
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
