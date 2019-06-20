//
//  DoctorReportDetailsTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/14/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//
import UIKit
import Firebase

class DoctorReportDetailsTableViewController: UITableViewController {
    var report : Reports?
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblReason: UITextView!
    @IBOutlet weak var lblName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let repdb = Database.database().reference().child("Report")
        repdb.child(self.report!.reportID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let date = value.value(forKey: "Date") as? String {
                     self.lblDateTime.text = date
                }
                if let reason = value.value(forKey: "Reason") as? String{
                     self.lblReason.text = reason
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        Database.database().reference().child("User").child(self.report!.patientID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                if let name = value.value(forKey: "Name") as? String{
                    self.lblName.text = name
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
}
