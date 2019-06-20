//
//  ListPastAppointmentTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/8/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class ListPastAppointmentTableViewController: UITableViewController {
    var appointments = [Appointment]()
    var keys = [String]()
    override func viewDidLoad() {
            super.viewDidLoad()
        let ref = Database.database().reference().child("Appointment")
        ref.queryOrdered(byChild: "DoctorID").queryEqual(toValue: (Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                if let value = child.value as? NSDictionary {
                    let app = Appointment()
                    app.appointmentID = child.key
                    if let date = value.value(forKey: "Date") as? String{
                         app.Date = date.toDate()
                    }
                    if let time = value.value(forKey: "Time") as? String{
                          app.Time = time
                    }
                    if let seekerID = value.value(forKey: "SeekerID") as? String {
                         app.seekerID = seekerID
                    }
                    if let seekerRate = value.value(forKey: "SeekerRate") as? Int {
                         app.seekerRate = seekerRate
                    }
                    if let desc = value.value(forKey: "Description") as? String {
                         app.Description = desc
                    }
                    self.appointments.append(app)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if(self.appointments.count == 0){
                    let alert = UIAlertController(title: "No Appointments", message: "you have no appointments that needs logs.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default){
                    action in
                         self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alert, animated: true)
                }
            }
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MM-yyyy"
            let date = dateFormatterGet.date(from: Date().description)
            let formatedDate = dateFormatterPrint.string(from: date!)
            self.appointments = self.appointments.filter({
                if $0.Date! < formatedDate.toDate(){
                    return true
                }else{
                    return false
                }
            })
        })
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  self.appointments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastAppointmentsCell", for: indexPath) as! PastAppointmentTableViewCell
        let ref = Database.database().reference().child("User")
        ref.child("\(self.appointments[indexPath.row].seekerID!)/Name").observeSingleEvent(of: .value, with: { (snapshot) in
            cell.lblName.text  = (snapshot.value as? String)!
        })
        cell.lblDateTime.text = appointments[indexPath.row].getDateTime()
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let s = UIStoryboard(name: "Doctor", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "detailsPastAppointment") as! DetailedPastAppointmentTableViewController
            vc.appointmentKey = self.appointments[indexPath.row].appointmentID!
            vc.SeekerID = self.appointments[indexPath.row].seekerID!
            self.navigationController!.pushViewController(vc, animated: true)
    }
}
