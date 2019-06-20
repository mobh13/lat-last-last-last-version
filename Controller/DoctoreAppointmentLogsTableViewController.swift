//
//  DoctoreAppointmentLogsTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/8/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
class DoctoreAppointmentLogsTableViewController: UITableViewController, UITextViewDelegate {
    @IBOutlet weak var seekerRating: CosmosView!
    @IBOutlet weak var lblName: UILabel!
    var appointmentKey = ""
    var seekerID = ""
    @IBOutlet weak var txtLog: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("User")
        ref.child("\(self.seekerID)/Name").observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                self.lblName.text = name
            }
            self.tableView.reloadData()
        })
        self.txtLog.delegate = self
        self.txtLog.text = "Please enter a description of the appointment."
        self.txtLog.textColor = UIColor.lightGray
        self.txtLog.isEditable = true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 1
        }
    }
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter a description of the appointment."
            textView.textColor = UIColor.lightGray
        }
    }

    @IBAction func btnDone(_ sender: Any) {
        if (self.txtLog.textColor == UIColor.lightGray && self.txtLog.text.isEmpty) {
            let alert = UIAlertController(title: "Empty!", message: "Please make sure to write a useful description of the appointment as it will be used to monitor our operation. Thank you!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go back!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
        Database.database().reference().child("Appointment/\(self.appointmentKey)/Description").setValue(self.txtLog.text)
        Database.database().reference().child("Appointment/\(self.appointmentKey)/SeekerRate").setValue(Int(self.seekerRating.rating))
            let alert = UIAlertController(title: "Success!", message: "Thank you for completing this appointment logs.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue!", style: .default, handler: {action in
                let s = UIStoryboard(name: "Doctor", bundle: nil)
                let vc = s.instantiateViewController(withIdentifier: "appointmentsLogs")
                vc.navigationItem.hidesBackButton = true
                self.navigationController!.pushViewController(vc, animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
}
