//
//  EditAccountTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/4/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class EditAccountTableViewController: UITableViewController ,UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    let db = Database.database().reference()
    let currentUID =  Auth.auth().currentUser?.uid

    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func loadData(){
       
      
//
        self.db.child("User").child(currentUID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
//                        for key in (value?.keyEnumerator())!{
//                            let row = value?.value(forKey: key as! String)
//                            if let actualIn = row {
//                              print(actualIn)
//                            }
//                        }
            if let  v = value?.value(forKey: "Username") as? String{

                self.usernameTextField.text = v
            }

        })
        if let em  = Firebase.Auth.auth().currentUser?.email {
            self.emailTextField.text = em
        }
        
        self.passwordTextField.text = "SimplePassword"
        
    }

    // MARK: - Table view data source

 
    @IBAction func updateAccountClicked(_ sender: Any) {
        
        if self.emailTextField.text ==  nil || self.passwordTextField.text ==  nil || self.usernameTextField.text  == nil {
            let alert = UIAlertController(title: "Error", message: "all information are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert,animated: true)
        }else{
            if self.emailTextField.text?.count ?? 0 > 10 && self.passwordTextField.text?.count ?? 0 > 6 && self.usernameTextField.text?.count ?? 0 > 3 {
                if let newPass = self.passwordTextField.text , newPass != "SimplePassword"{
                    Auth.auth().currentUser?.updatePassword(to: newPass, completion: nil)

                }
                let newEmail = self.emailTextField.text!
                let newUsername = self.usernameTextField.text!
                Auth.auth().currentUser?.updateEmail(to: newEmail, completion: nil)
               db.child("User").child(currentUID!).child("Email").setValue(newEmail)
                db.child("User").child(currentUID!).child("Username").setValue(newUsername)
                
                let alert = UIAlertController(title: "Updated", message: "AccountUpdated", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert,animated: true)
            }
             else if self.passwordTextField.text!.count < 6{
                let alert = UIAlertController(title: "Error", message: "Password must be at least 7 charachters", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert,animated: true)
            }else if self.usernameTextField.text!.count < 6{
                let alert = UIAlertController(title: "Error", message: "username must be at least 3 charachters", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert,animated: true)
            }else if self.emailTextField.text!.count < 6{
                let alert = UIAlertController(title: "Error", message: "email must be at least 10 charachters", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert,animated: true)
            }
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
