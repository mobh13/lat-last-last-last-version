//
//  EditProfileTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/4/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableViewController: UITableViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate{
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var txtClincBuilding: UITextField!
    @IBOutlet weak var txtClincStreet: UITextField!
    @IBOutlet weak var txtClincBlock: UITextField!
    @IBOutlet weak var txtClincCity: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtClincName: UITextField!
    @IBOutlet weak var txtSpeciality: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCPR: UITextField!
    @IBOutlet var txtInput: [UITextField]!
    var imageChanged = false
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    @IBAction func btnSave(_ sender: UIButton) {
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
                self.txtClincBuilding.text!.isNumeric else{
                    valid = false
                    let alert = UIAlertController(title: "Invalid input", message: "Please make sure that fields such as Phone number, CPR, clinc's block / street / block are all numeric. And if they are, make sure you have the same password in both fields.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
            }
            if(valid && !empty){
                let ref = Database.database().reference()
                let doctorID = Auth.auth().currentUser?.uid
                ref.child("User/\(doctorID!)").child("Name").setValue(self.txtName!.text)
                ref.child("User/\(doctorID!)").child("clincBlock").setValue(self.txtClincBlock!.text)
                ref.child("User/\(doctorID!)").child("ClincBuilding").setValue(self.txtClincBuilding!.text)
                ref.child("User/\(doctorID!)").child("ClincCity").setValue(self.txtClincCity!.text)
                ref.child("User/\(doctorID!)").child("ClincName").setValue(self.txtClincName!.text)
                ref.child("User/\(doctorID!)").child("ClincStreet").setValue(self.txtClincStreet!.text)
                ref.child("User/\(doctorID!)").child("CPR").setValue(self.txtCPR!.text)
                Auth.auth().currentUser?.updateEmail(to: self.txtEmail!.text!, completion: nil)
                ref.child("User/\(doctorID!)").child("Email").setValue(self.txtEmail!.text)
                if self.txtPassword.hasText{
                    Auth.auth().currentUser?.updatePassword(to: self.txtPassword!.text!, completion: nil)
                }
                ref.child("User/\(doctorID!)").child("PhoneNumber").setValue(self.txtNumber!.text)
                ref.child("User/\(doctorID!)").child("Speciality").setValue(self.txtSpeciality!.text)
                ref.child("User/\(doctorID!)").child("Username").setValue(self.txtUsername!.text)
                if(self.imageChanged == true){
                    sender.isEnabled = false
                    self.progressBar.isHidden = false
                    var key = ref.childByAutoId().key
                    ref.child(key!).removeValue()
                    key?.append(".png")
                    print(key!)
                    let storRef = Storage.storage().reference().child(key!)
                    let uploadTask = storRef.putData(self.pictureView.image!.pngData()!, metadata: nil) { (metadata, error) in
                        if error != nil {
                             sender.isEnabled = true
                            let alert = UIAlertController(title: "Picture Error!", message: "Default picture has been set. "+error!.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            Database.database().reference().child("User/\(doctorID!)").child("PicturePath").setValue("profilepic.png")
                            return
                        }else{
                            sender.isEnabled = true
                            Database.database().reference().child("User/\(doctorID!)").child("PicturePath").setValue(key!)
                        }
                    }
                    uploadTask.observe(.progress) { snapshot in
                         self.progressBar.progress = Float(snapshot.progress!.fractionCompleted)
                    }
                    uploadTask.observe(.success) { (snapshot) in
                        let alert = UIAlertController(title: "Success", message: "Your information has been successfully updated on our servers.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { action in
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }))
                        sender.isEnabled = true
                        self.present(alert, animated: true)
                    }
                }else{
                    let alert = UIAlertController(title: "Success", message: "Your information has been successfully updated on our servers.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { action in
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in txtInput {
            i.delegate = self
        }
        self.progressBar.isHidden = true
        let db = Database.database().reference().child("User")
        let uid = Auth.auth().currentUser?.uid
        db.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let picID = value.value(forKey: "PicturePath") as? String {
                    let storageRef = Storage.storage().reference().child(picID)
                    storageRef.downloadURL { url, error in
                        guard let url = url else { return }
                        self.pictureView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: nil)
                    }
                }
                if let cpr = value.value(forKey: "CPR") as? String {
                    self.txtCPR.text = cpr
                }
                if let city = value.value(forKey: "ClincCity") as? String {
                    self.txtClincCity.text = city
                }
                if let street = value.value(forKey: "ClincStreet") as? String {
                    self.txtClincStreet.text = street
                }
                if let number = value.value(forKey: "PhoneNumber") as? String {
                    self.txtNumber.text = number
                }
                if let building = value.value(forKey: "ClincBuilding") as? String {
                    self.txtClincBuilding.text = building
                }
                if let cName = value.value(forKey: "ClincName") as? String {
                    self.txtClincName.text = cName
                }
                if let name = value.value(forKey: "Name") as? String {
                    self.txtName.text = name
                }
                if let block = value.value(forKey: "ClincBlock") as? String {
                    self.txtClincBlock.text = block
                }
                if let username = value.value(forKey: "Username") as? String {
                    self.txtUsername.text = username
                }
                if let speciality = value.value(forKey: "Speciality") as? String {
                    self.txtSpeciality.text = speciality
                }
                    self.txtEmail.text = Auth.auth().currentUser?.email
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 11
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0,1,2,3,4,5,6,7,8:
            return 1
        case 9:
            return 4
        case 10:
            return 2
        default:
            return 1
        }
    }
    @IBAction func promptPicture(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take a Photo", style: .default, handler: { (_) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        present(alertController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
 
        guard let image = info[.originalImage] as? UIImage else {return}
        self.pictureView.image = image
        self.imageChanged = true
        dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.imageChanged = false
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
