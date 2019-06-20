//
//  ShowVolunteerTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/14/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class ShowVolunteerTableViewController: UITableViewController {

    var id:String?
    @IBOutlet weak var imgPicture: UIImageView!
    
    @IBOutlet weak var lblCpr: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblDOB: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        loadData()
    }
    func loadData(){
        if self.id != nil {
            let db = Database.database().reference().child("User")
            let uid = self.id
            db.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let storageRef = Storage.storage().reference().child(value?.value(forKey: "PicturePath") as! String)
                storageRef.downloadURL { url, error in
                    guard let url = url else { return }
                    self.imgPicture.kf.setImage(with: url)
                }
                
                
                    if let phone = value!.value(forKey: "PhoneNumber") as? String
                    {
                        self.lblNumber.text = phone
                }
                
                if let name = value!.value(forKey: "Name") as? String{
                    self.lblName.text = name
                }
                
                if let username = value!.value(forKey: "Username") as? String {
                     self.lblUsername.text = username
                }
              if let role = value!.value(forKey: "Role") as? String {
                       self.lblRole.text = role
                }
              if let cpr  = value!.value(forKey: "CPR") as? String {
                       self.lblCpr.text = cpr
                }
               if let email = value!.value(forKey: "Email") as? String {
                      self.lblEmail.text = email
                }
                 if let dob = value!.value(forKey: "DOB") as? String {
                    self.lblDOB.text = dob
                }
            }) { (error) in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oh No!", style: .default, handler: {
                    action in
                    
                    self.navigationController!.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }}
    @IBAction func editClicked(_ sender: Any) {
        
        let s = UIStoryboard(name: "Admin", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "EditVolunteerTableViewController") as!  EditVolunteerTableViewController
        vc.id = self.id
        
        self.navigationController?.pushViewController(vc, animated: true)
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
