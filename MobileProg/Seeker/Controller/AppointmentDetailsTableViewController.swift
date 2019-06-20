//
//  AppointmentDetailsTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/20/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class AppointmentDetailsTableViewController: UITableViewController {
    var appID = ""
    var isRated = false
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDoctor: UILabel!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Database.database().reference().child("Appointment")
        db.child(appID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let date = value.value(forKey: "Date") as? String {
                    self.lblDate.text = date
                }
                if let time = value.value(forKey: "Time") as? String {
                    self.lblTime.text = time
                }
                if let desc = value.value(forKey: "Description") as? String {
                    self.txtDesc.text = desc
                }
                if let rate = value.value(forKey: "DoctorRate") as? Int {
                    if rate == 0 {
                        self.btn.isEnabled = false
                    }else{
                        self.btn.isEnabled = true
                    }
                }
                if let docID = value.value(forKey: "DoctorID") as? String {
                    Database.database().reference().child("User").child("\(docID)/Name").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let name = snapshot.value as? String {
                            self.lblDoctor.text = name
                        }else{
                            self.lblDoctor.text = "Invalid Name"
                        }
                    })
                }
            }
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Oh No!", style: .default, handler: {
                action in
                let s = UIStoryboard(name: "Doctor", bundle: nil)
                let vc = s.instantiateViewController(withIdentifier: "Dashboard")
                self.navigationController!.pushViewController(vc, animated: true)
            }))
            self.present(alert, animated: true)
        }
    }

    @IBAction func goToRateDoctor(_ sender: Any) {
        let s = UIStoryboard(name: "Seeker", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "RateDoctor") as! RateDoctorTableViewController
        vc.appointmentId = self.appID
        self.navigationController!.pushViewController(vc, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
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
