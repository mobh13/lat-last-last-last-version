//
//  ListAppointmentsForLogsTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/12/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import  Firebase

class ListAppointmentsForLogsTableViewController: UITableViewController {
    var appointments = [Appointment]()
    var keys = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("Appointment")
        ref.queryOrdered(byChild: "DoctorID").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                if let value = child.value as? NSDictionary {
                let app = Appointment()
                app.appointmentID = child.key
                    if let date = value.value(forKey: "Date") as? String {
                         app.Date = date.toDate()
                    }
                    if let time = value.value(forKey: "Time") as? String {
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
            self.appointments = self.appointments.filter({
                if $0.seekerRate == nil && $0.Description!.isEmpty {
                    return true
                }else{
                    return false
                }
            })
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if(self.appointments.count == 0){
                let alert = UIAlertController(title: "No Appointments", message: "you have no appointments that needs logs.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay!", style: .default){action in
                    self.navigationController?.popViewController(animated: true)
                    })
                self.present(alert, animated: true)
            }
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  self.appointments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentsNeedsLogs", for: indexPath) as! AppointmentsNeedLogsTableViewCell
        let ref = Database.database().reference().child("User")
        ref.child("\(self.appointments[indexPath.row].seekerID!)/Name").observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                 cell.lblName.text = name
            }else{
                  cell.lblName.text = "Invalid Name"
            }
        })
        cell.lblDateTime.text = appointments[indexPath.row].getDateTime()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = UIStoryboard(name: "Doctor", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "enterLogs") as! DoctoreAppointmentLogsTableViewController
        vc.appointmentKey = self.appointments[indexPath.row].appointmentID!
        vc.seekerID = self.appointments[indexPath.row].seekerID!
        self.navigationController!.pushViewController(vc, animated: true)
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
