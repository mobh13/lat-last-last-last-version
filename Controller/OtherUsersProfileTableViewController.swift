//
//  OtherUsersProfileTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/8/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class OtherUsersProfileTableViewController: UITableViewController {
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    var userID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!self.userID.isEmpty){
            let db = Database.database().reference().child("User")
            db.child(self.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    if let picPath = value.value(forKey: "PicturePath") as? String {
                        let storageRef = Storage.storage().reference().child(picPath)
                        storageRef.downloadURL { url, error in
                            guard let url = url else { return }
                            self.pictureView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: nil)
                        }
                    }
                    if let name = value.value(forKey: "Name") as? String {
                          self.lblName.text = name
                    }
                    if let username = value.value(forKey: "Username") as? String {
                         self.lblUsername.text = username
                    }
                    if let email = value.value(forKey: "Email") as? String {
                        self.lblEmail.text = email
                    }
                }
            }) {(error) in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oh No!", style: .default, handler: {
                    action in
                    let s = UIStoryboard(name: "Doctor", bundle: nil)
                    let vc = s.instantiateViewController(withIdentifier: "Dashboard")
                    self.navigationController!.pushViewController(vc, animated: true)
                }))
                self.present(alert, animated: true)
            }
        }else{
            let s = UIStoryboard(name: "Doctor", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "doctorSearch")
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnReport(_ sender: Any) {
        let s = UIStoryboard(name: "Doctor", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "enterReport") as! EnterReportTableViewController
        vc.userName = self.lblName.text!
        vc.userID = self.userID
        self.navigationController!.pushViewController(vc, animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
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
