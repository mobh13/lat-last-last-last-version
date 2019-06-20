//
//  SeekerViewDoctorProfileTableViewController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/17/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage




class SeekerViewDoctorProfileTableViewController: UITableViewController {
 var selectedDoctor: Doctor?
    var currentSeeker:String = ""
    var userId:String?
    
    @IBOutlet weak var profileImg: UIImageView!
   
    @IBOutlet weak var lblClincBuilding: UILabel!
    @IBOutlet weak var lblClincStreet: UILabel!
    @IBOutlet weak var lblClincBlock: UILabel!
    @IBOutlet weak var lblClincCity: UILabel!
    @IBOutlet weak var lblClincName: UILabel!
    @IBOutlet weak var DoctorPhoneNumber: UILabel!
    @IBOutlet weak var DoctorUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpeciality: UILabel!
    
  
    @IBAction func btnBookAppointmentclicked(_ sender: Any) {
        
        
    }
    
    func getImage() {
        let ref = Database.database().reference()
        ref.child("User").observe(.value, with: {(snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let userID = child.key as String //get autoID
                    ref.child("User/\(userID)/Id").observe(.value, with: { (snapshot) in
                        if let id = snapshot.value as? String {
                            //change this ID and put current uid
                            if id == self.currentSeeker {
                                let dict = child.value as! [String: Any]
                                let path = dict["PicturePath"] as! String
                                let storageRef = Storage.storage().reference().child(path)
                                storageRef.downloadURL {
                                    url, error in guard let url = url else { return }
                                    self.profileImg.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: nil)
                                }
                            }
                        }
                    })
                }
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let userID = Auth.auth().currentUser?.uid {
            self.currentSeeker = userID
            
            
           
            self.DoctorUsername.text = String(self.selectedDoctor!.name!)
           self.DoctorPhoneNumber.text = String(self.selectedDoctor!.phoneNumber!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
    }

    
        override func viewDidAppear(_ animated: Bool) {
            if let id = userId{
                let db = Database.database().reference().child("User")
                db.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        if let picID = value.value(forKey: "PicturePath") as? String {
                            
                            let storageRef = Storage.storage().reference().child(picID)
                            storageRef.downloadURL { url, error in
                                guard let url = url else { return }
                                self.profileImg.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: nil)
                            }
                        }
                        
                        
                        if let city = value.value(forKey: "ClincCity") as? String {
                            self.lblClincCity.text = city
                        }
                        if let street = value.value(forKey: "ClincStreet") as? String {
                            self.lblClincStreet.text = street
                        }
                        if let number = value.value(forKey: "PhoneNumber") as? String {
                            self.DoctorPhoneNumber.text = number
                        }
                        if let building = value.value(forKey: "ClincBuilding") as? String {
                            self.lblClincBuilding
                                .text = building
                        }
                        if let cName = value.value(forKey: "ClincName") as? String {
                            self.lblClincName.text = cName
                        }
                        if let name = value.value(forKey: "Name") as? String {
                            self.lblName.text = name
                        }
                        if let block = value.value(forKey: "ClincBlock") as? String {
                            self.lblClincBlock.text = block
                        }
                        if let username = value.value(forKey: "Username") as? String {
                            self.DoctorUsername.text = username
                        }
                        if let Email = value.value(forKey: "Email") as? String {
                            self.lblEmail.text = Email
                        }
                        if let speciality = value.value(forKey: "Speciality") as? String {
                            self.lblSpeciality.text = speciality
                        }
                    }
                    
                }){(error) in
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Oh No!", style: .default, handler: {
                        action in
                        let s = UIStoryboard(name: "Seeker", bundle: nil)
                        let vc = s.instantiateViewController(withIdentifier: "ListUsers") as! SeekerListUsersTableViewController
                      
                  
                        self.navigationController!.pushViewController(vc, animated: true)
                      }))
                    
                    
                   
                    
                    self.present(alert, animated: true)
                }
            }
         
            
            
            
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


