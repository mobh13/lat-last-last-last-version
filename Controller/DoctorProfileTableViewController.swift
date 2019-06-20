//
//  DoctorProfileTableViewController.swift
//
//
//  Created by Abudlla Ali on 6/3/19.
//

import UIKit
import Firebase
import SDWebImage

class DoctorProfileTableViewController: UITableViewController {
    
    @IBAction func btnEdit(_ sender: Any) {
        let s = UIStoryboard(name: "Doctor", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "doctorEditProfile")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    @IBAction func logOut(_ sender: Any) {
        let alert = UIAlertController(title: "Logout!", message: "Are you sure you want to logout from this ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {action in
            do
            {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainScreen")
                 self.navigationController!.pushViewController(vc, animated: true)
            }
            catch let error as NSError
            {
                let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oh No!", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }

        }))
        alert.addAction(UIAlertAction(title: "Go Back", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBOutlet weak var lblClincBuilding: UILabel!
    @IBOutlet weak var lblClincStreet: UILabel!
    @IBOutlet weak var lblClincBlock: UILabel!
    @IBOutlet weak var lblClincCity: UILabel!
    @IBOutlet weak var lblClincName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCPR: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblSpeciality: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        let db = Database.database().reference().child("User")
        let uid = Auth.auth().currentUser?.uid
            db.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    if let picID = value.value(forKey: "PicturePath") as? String {
                        let storageRef = Storage.storage().reference().child(picID)
                        storageRef.downloadURL { url, error in
                            guard let url = url else { return }
                            self.imgPicture.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: nil)
                        }
                    }
                    if let cpr = value.value(forKey: "CPR") as? String {
                        self.lblCPR.text = cpr
                    }
                    if let city = value.value(forKey: "ClincCity") as? String {
                        self.lblClincCity.text = city
                    }
                    if let street = value.value(forKey: "ClincStreet") as? String {
                         self.lblClincStreet.text = street
                    }
                    if let number = value.value(forKey: "PhoneNumber") as? String {
                         self.lblNumber.text = number
                    }
                    if let building = value.value(forKey: "ClincBuilding") as? String {
                        self.lblClincBuilding.text = building
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
                          self.lblUsername.text = username
                    }
                    if let speciality = value.value(forKey: "Speciality") as? String {
                        self.lblSpeciality.text = speciality
                    }
                }
                self.lblEmail.text = Auth.auth().currentUser?.email
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
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0,1,2,3,4,5,6,7,9:
            return 1
        case 8:
            return 4
        default:
            return 1
        }
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
