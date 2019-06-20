//
//  EditProfileTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/4/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EditDoctorProfileTableViewController: UITableViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

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
    
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var txtCPR: UITextField!
    @IBOutlet var txtInput: [UITextField]!
    var id:String?
    var pictureChanged = false

    @IBAction func exit(_ sender: Any) {
        let alert = UIAlertController(title: "Exit!", message: "Are you sure you want to exit without saving?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit!", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Return", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
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
                let ref = Database.database().reference().child("User")
                let doctorID = self.id
                ref.child(doctorID!).child("Name").setValue(self.txtName!.text)
                ref.child(doctorID!).child("clincBlock").setValue(self.txtClincBlock!.text)
                ref.child(doctorID!).child("ClincBuilding").setValue(self.txtClincBuilding!.text)
                ref.child(doctorID!).child("ClincCity").setValue(self.txtClincCity!.text)
                ref.child(doctorID!).child("ClincName").setValue(self.txtClincName!.text)
                ref.child(doctorID!).child("ClincStreet").setValue(self.txtClincStreet!.text)
                ref.child(doctorID!).child("CPR").setValue(self.txtCPR!.text)
                ref.child(doctorID!).child("PhoneNumber").setValue(self.txtNumber!.text)
                ref.child(doctorID!).child("Speciality").setValue(self.txtSpeciality!.text)
                ref.child(doctorID!).child("Username").setValue(self.txtUsername!.text)
                
                if pictureChanged == true{
                    var key = Database.database().reference().childByAutoId().key
                    Database.database().reference().child(key!).removeValue()
                    key?.append(".png")
                    let storRef = Storage.storage().reference().child(key!)
                    if self.pictureView.image?.pngData() != nil {
                        let uploadTask = storRef.putData(self.pictureView.image!.pngData()!, metadata: nil) { (metadata, error) in
                            if error != nil {
                                let alert = UIAlertController(title: "Picture Error!", message: "Default picture has been set. "+error!.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                                self.present(alert, animated: true)
                                return
                            }else{
                                ref.child(doctorID!).child("PicturePath").setValue(key!)
                            }
                        }
                        uploadTask.observe(.progress) { snapshot in
                            self.progressBar.isHidden = false
                            self.progressBar.progress = Float(snapshot.progress!.fractionCompleted)
                            self.changeBtn.isHidden = true
                        }
                        uploadTask.observe(.success) { (snapshot) in
                            let alert = UIAlertController(title: "Success", message: "Your information has been successfully updated on our servers.", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { action in
                                DispatchQueue.main.async {
                                    
                                    self.navigationController?.popViewController(animated: true)
                                    self.present(alert, animated: true)
                                    
                                }
                            }
                            ))
                        }
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
 self.progressBar.isHidden = true
        let db = Database.database().reference().child("User")
        let uid = self.id
    
        db.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storageRef = Storage.storage().reference().child(value?.value(forKey: "PicturePath") as! String)
            storageRef.downloadURL { url, error in
                guard let url = url else { return }
               
                self.pictureView.kf.setImage(with: url)
            }
            if let cpr = value!.value(forKey: "CPR") as? String{
                self.txtCPR.text = cpr
            }
            if let city  = value!.value(forKey: "ClincCity") as? String
            {
                self.txtClincCity.text = city
            }
            
            if let street =  value!.value(forKey: "ClincStreet") as? String {
                self.txtClincStreet.text = street
            }
          
            if let pn =  value!.value(forKey: "PhoneNumber") as? String {
                self.txtNumber.text = pn
            }
            if let clinic =  value!.value(forKey: "ClincBuilding") as? String {
                self.txtClincBuilding.text = clinic
            }
            
            if let cname = value!.value(forKey: "ClincName") as? String{
                self.txtClincName.text = cname
            }
            
            if let name  = value!.value(forKey: "Name") as? String{
                self.txtName.text = name
            }
            if let block  = value!.value(forKey: "ClincBlock") as? String{
                self.txtClincBlock.text = block
            }
            if let username = value!.value(forKey: "Username") as? String{
                self.txtUsername.text = username
            }
            if let  sp = value!.value(forKey: "Speciality") as? String {
                self.txtSpeciality.text = sp
            }
        })
    }

    // MARK: - Table view data source


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
        self.pictureChanged = true
        dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.pictureChanged = false
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
