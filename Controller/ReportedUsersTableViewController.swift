//
//  ReportedUsersTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/8/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class ReportedUsersTableViewController: UITableViewController {
    var reports = [Reports]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let ref = Database.database().reference().child("Report")
        ref.queryOrdered(byChild: "By").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                let value = child.value as! NSDictionary
                let rep = Reports()
                rep.reportID = child.key
                if let dateTime = value.value(forKey: "Date") as? String {
                     rep.DateTime = dateTime
                }
                if let user = value.value(forKey: "User") as? String {
                     rep.patientID = user
                }
                if let reason = value.value(forKey: "Reason") as? String {
                     rep.Reason = reason
                }
                self.reports.append(rep)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if(self.reports.count == 0){
                    let alert = UIAlertController(title: "No Reports", message: "you have no users that have  been reported.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default) {action in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alert, animated: true)
                }
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
        return reports.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repotDetailsCell", for: indexPath) as! ReportsListTableViewCell
        let namedb = Database.database().reference().child("User")
        namedb.child(self.reports[indexPath.row].patientID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                 if let name = value["Name"] as? String {
                    cell.lblName.text =  name
                 }else{
                    cell.lblName.text = "User name is invalid"
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        let dateTrim : String = (self.reports[indexPath.row].DateTime)!
        cell.lblDate.text = String(dateTrim.prefix(10))
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let s = UIStoryboard(name: "Doctor", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "reportDetails") as! DoctorReportDetailsTableViewController
            vc.report = self.reports[indexPath.row]
            self.navigationController!.pushViewController(vc, animated: true)
    }
}
