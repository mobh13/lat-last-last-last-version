//
//  SeekerProfileTableViewController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/17/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class SeekerProfileTableViewController: UITableViewController {
   
   
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var DOB: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var CPR: UILabel!
    
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func editclicked(_ sender: Any) {
        let s = UIStoryboard(name: "Seeker", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "seekerEditProfile")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let db = Database .database().reference().child("User")
//        if let uid = Auth.auth().currentUser?.uid{
        db.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: {
            (snapchot) in
            if let value = snapchot.value as? NSDictionary{
                    if let picID = value.value(forKey: "PicturePath") as? String {
                        let storageRef = Storage.storage().reference().child(picID)
                        
                        storageRef.downloadURL { url, error in
                            guard let url = url else { return }
                            self.profileImg!.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: nil)
                        }
                }
                    if let cpr = value.value(forKey: "CPR") as? String {
                        self.CPR.text = cpr
                    }
                    if let number = value.value(forKey: "PhoneNumber") as? String {
                        self.phone.text = number
                    }
                    if let name = value.value(forKey: "Name") as? String {
                        self.name.text = name
                    }
                    
                    if let gender = value.value(forKey: "gender") as? String {
                        if gender == "male"{
                            self.gender.selectedSegmentIndex = 0
                        }else{
                            self.gender.selectedSegmentIndex = 1

                        }
                       
                    }
                self.email.text = Auth.auth().currentUser?.email

                
            }
        })
        
                    
        }
        



    // MARK: - Table view data source

 
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
