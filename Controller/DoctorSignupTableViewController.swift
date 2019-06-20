//
//  DoctorSignupTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/2/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//
import UIKit
import Firebase


class DoctorSignupTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCPR: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtClincName: UITextField!
    @IBOutlet weak var txtClincCity: UITextField!
    @IBOutlet weak var txtClincBlock: UITextField!
    @IBOutlet weak var txtClincStreet: UITextField!
    @IBOutlet weak var txtClincBuilding: UITextField!
    
    @IBOutlet weak var txtSpeciality: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet var txtInput: [UITextField]!
    
    @IBAction func goToLegal(_ sender: Any) {
        let s = UIStoryboard(name: "Doctor", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "legalPage")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnExit(_ sender: UIButton) {
        let s = UIStoryboard(name: "Main", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "Login")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        var valid = true
        var empty = false
        for textField in self.txtInput {
            if !textField.hasText {
                empty = true
            }
        }
        if !empty {
            guard self.txtCPR.text!.isNumeric,
                self.txtNumber.text!.isNumeric,
                self.txtClincBlock.text!.isNumeric,
                self.txtClincStreet.text!.isNumeric,
                self.txtClincBuilding.text!.isNumeric,
                self.txtPassword.text!.isEqual(self.txtConfirmPassword.text!) else{
                    valid = false
                    let alert = UIAlertController(title: "Invalid input", message: "Please make sure that fields such as Phone number, CPR, clinc's block / street / block are all numeric. And if they are, make sure you have the same password in both fields.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
            }
            if(valid && !empty){
                Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { user, error in
                    if error == nil {
                        let doc = Doctor()
                        doc.name = self.txtName.text
                        doc.phoneNumber = self.txtNumber.text!
                        doc.CPR = self.txtCPR.text!
                        doc.clincCity = self.txtClincCity.text
                        doc.clincName = self.txtClincName.text
                        doc.clincBlock = self.txtClincBlock.text!
                        doc.clincStreet = self.txtClincStreet.text!
                        doc.clincBuidling = self.txtClincBuilding.text!
                        doc.speciality = self.txtSpeciality.text!
                        doc.username = self.txtUsername.text!
                        let db = Database.database().reference().child("User");
                        let date = Date()
                        let format = DateFormatter()
                        format.dateFormat = "dd-MM-yyyy HH:mm:ss"
                        let formattedDate = format.string(from: date)
                        let docDB = ["Name": doc.name!,
                                     "PhoneNumber": doc.phoneNumber!,
                                     "CPR": doc.CPR!,
                                     "ClincName": doc.clincName!,
                                     "ClincCity": doc.clincCity!,
                                     "ClincBlock": doc.clincBlock!,
                                     "ClincStreet": doc.clincStreet!,
                                     "ClincBuilding": doc.clincBuidling!,
                                     "Email" : self.txtEmail.text!,
                                     "PicturePath": " ",
                                     "IsBlocked" : false,
                                     "IsReported" : false,
                                     "Status": "Pending",
                                     "Role" : "Doctor",
                                     "Speciality" : doc.speciality!,
                                     "Username" : doc.username!,
                                     "RegistrationDate" : formattedDate
                            ] as [String : Any]
                        let key = Auth.auth().currentUser?.uid
                        db.child(key!).setValue(docDB)
                        let alert = UIAlertController(title: "Success", message: "You have successfully signed up to the applicaiton.", preferredStyle: .alert)
                        let nextAction = UIAlertAction(title: "Next!", style: .default) { action in
                            let s = UIStoryboard(name: "Doctor", bundle: nil)
                            let vc = s.instantiateViewController(withIdentifier: "authenticateDoctor")
                            self.navigationController!.pushViewController(vc, animated: true)
                        }
                        alert.addAction(nextAction)
                        self.present(alert, animated: true)
                    }
                    else{
                        let alert = UIAlertController(title: "Error!", message: error?.localizedDescription , preferredStyle: .alert)
                        let nextAction = UIAlertAction(title: "Try Again!", style: .default)
                        alert.addAction(nextAction)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        else{
                let alert = UIAlertController(title: "Error", message: "Please make sure that all fields contain valid information information (No Empty fields / Numeric values only in (CPR, Block, Street, Building, Phone number))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Go Back!", style: .default, handler: nil))
                self.present(alert, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in self.txtInput {
            i.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0,1,2,3,4,7,8:
            return 1
        case 5,9:
            return 2
        case 6:
            return 5
        
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
