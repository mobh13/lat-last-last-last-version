//
//  DetailedPastAppointmentTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/8/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
class DetailedPastAppointmentTableViewController: UITableViewController, UITextViewDelegate {
    var appointmentKey = ""
    var SeekerID = ""
    @IBOutlet weak var txtLog: UITextView!
    @IBOutlet weak var seekerRate: CosmosView!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblPatientName: UILabel!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtLog.delegate = self
        var dateTime : String?
        let appdb = Database.database().reference().child("Appointment/\(appointmentKey)")
        appdb.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let seekerRate = value.value(forKey: "SeekerRate") as? Int{
                     self.seekerRate.rating = Double(seekerRate)
                }
                if let desc = value.value(forKey: "Description") as? String {
                     self.txtLog.text = desc
                }
                if let date = value.value(forKey: "Date") as? String {
                    dateTime = date
                        dateTime?.append(" / ")
                }
                if let time = value.value(forKey: "Time") as? String{
                    dateTime?.append(time)
                    self.lblDateTime.text = dateTime
                }
                self.tableView.reloadData()
            }
        })
        
        let ref = Database.database().reference().child("User")
        ref.child("\(self.SeekerID)/Name").observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                 self.lblPatientName.text = name
            }
             self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
}
