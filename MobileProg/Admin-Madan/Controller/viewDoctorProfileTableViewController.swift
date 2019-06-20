//
//  DoctorProfileTableViewController.swift
//
//
//  Created by Abudlla Ali on 6/3/19.
//

import UIKit
import Firebase
import Kingfisher

class AdminDoctorProfileTableViewController: UITableViewController {
    
    @IBAction func edit(_ sender: Any) {
        let s = UIStoryboard(name: "Admin", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "doctorEditProfile") as! EditDoctorProfileTableViewController
        vc.id = self.id
        self.navigationController!.pushViewController(vc, animated: true)
    }
 
    
    @IBOutlet weak var lblRole: UILabel!
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
    
    var id:String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        let db = Database.database().reference().child("User")
        let uid = self.id
        db.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let pic = value?.value(forKey: "PicturePath") as? String{
                let storageRef = Storage.storage().reference().child(pic)
                storageRef.downloadURL { url, error in
                    guard let url = url else { return }
                    self.imgPicture.kf.setImage(with: url)
                }
            }
         
            if let cpr = value!.value(forKey: "CPR") as? String{
                  self.lblCPR.text = cpr
            }
            if let city  = value!.value(forKey: "ClincCity") as? String
            {
                  self.lblClincCity.text = city
            }
          
            if let street =  value!.value(forKey: "ClincStreet") as? String {
                self.lblClincStreet.text = street
            }
            if let role =  value!.value(forKey: "Role") as? String {
                self.lblRole.text = role
            }
            if let pn =  value!.value(forKey: "PhoneNumber") as? String {
                self.lblNumber.text = pn
            }
            if let clinic =  value!.value(forKey: "ClincBuilding") as? String {
                self.lblClincBuilding.text = clinic
            }
            
            if let cname = value!.value(forKey: "ClincName") as? String{
                 self.lblClincName.text = cname
            }
           
            if let name  = value!.value(forKey: "Name") as? String{
                  self.lblName.text = name
            }
            if let block  = value!.value(forKey: "ClincBlock") as? String{
                self.lblClincBlock.text = block
            }
            if let username = value!.value(forKey: "Username") as? String{
                self.lblUsername.text = username
            }
            if let  sp = value!.value(forKey: "Speciality") as? String {
                self.lblSpeciality.text = sp
            }
            if let em = value!.value(forKey: "Email") as? String {
                 self.lblEmail.text = em
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
