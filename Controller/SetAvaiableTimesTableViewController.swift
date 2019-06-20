//
//  SetAvaiableTimesTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/8/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class SetAvaiableTimesTableViewController: UITableViewController {

    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var fromTime: UIDatePicker!
    @IBOutlet weak var toTime: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        date.minimumDate = Date()
        date.maximumDate = Calendar.current.date(byAdding: .weekday, value: 8, to: Date())
        fromTime.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)

}
    @objc func datePickerChanged(picker: UIDatePicker) {
        toTime.minimumDate = fromTime.date
    }
    @IBAction func btnDone(_ sender: Any) {
        let db = Database.database().reference().child("AvailableTimes");
        let key = Database.database().reference().childByAutoId().key
        Database.database().reference().child(key!).removeValue()
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.timeZone = TimeZone.autoupdatingCurrent
        timeFormatter.timeStyle = DateFormatter.Style.short
        timeFormatter.dateFormat = "hh:mm a"
        let formatFrom = timeFormatter.string(from: self.fromTime.date)
        let formatTo = timeFormatter.string(from: self.toTime.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let formatDate = dateFormatter.string(from: self.date.date)
        if let uid = Auth.auth().currentUser?.uid {
            let docDB = ["Date": formatDate,
                         "From": formatFrom,
                         "To": formatTo,
                         "DoctorID": uid,
                ] as [String : Any]
            db.child(key!).setValue(docDB)
        }
        let alert = UIAlertController(title: "Success", message: "Your avaiable times are now set.", preferredStyle: .alert)
        let nextAction = UIAlertAction(title: "Okay!", style: .default) { action in
            self.date.date = Date()
            self.toTime.date = Date()
            self.fromTime.date = Date()
        }
        alert.addAction(nextAction)
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
