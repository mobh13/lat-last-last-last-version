//
//  EnterReportTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/12/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class EnterReportTableViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet weak var lblName: UILabel!
    var userID = ""
    var userName = ""
    @IBOutlet weak var txtReport: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblName.text = self.userName
        self.txtReport.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    @IBAction func btnDone(_ sender: Any) {
        if(self.txtReport.hasText){
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let formattedDate = format.string(from: date)
            let db = Database.database().reference().child("Report")
            if let uid = Auth.auth().currentUser?.uid {
                let report = [
                    "By" : uid,
                    "Date" : formattedDate,
                    "Reason" : self.txtReport.text,
                    "User" : self.userID
                    ] as [String : Any]
                db.childByAutoId().setValue(report)
            }
            Database.database().reference().child("User").child(self.userID).child("IsReported").setValue(true)
            let alert = UIAlertController(title: "Success!", message: "Ther report has been submited and saved to our servers. The admin will look into it and follow up with you.", preferredStyle: .alert)
            let nextAction = UIAlertAction(title: "Okay!", style: .default) { action in
                let s = UIStoryboard(name: "Doctor", bundle: nil)
                let vc = s.instantiateViewController(withIdentifier: "doctorSearch")
                vc.navigationItem.hidesBackButton = true
                vc.tabBarController?.tabBar.isHidden = false;
                self.navigationController!.pushViewController(vc, animated: true)
            }
            alert.addAction(nextAction)
            self.present(alert, animated: true)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
}
