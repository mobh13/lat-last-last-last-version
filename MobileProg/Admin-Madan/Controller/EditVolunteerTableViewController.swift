//
//  EditVolunteerTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/14/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase


class EditVolunteerTableViewController : UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
        
        var id:String?
       var pictureChanged = false
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtCPR: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var pickerDOB: UIDatePicker!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var changeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
         loadData()
        self.progressBar.isHidden = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        txtUsername.delegate = self
        txtCPR.delegate = self
        txtName.delegate = self
        txtPhoneNumber.delegate = self
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    override func viewWillAppear(_ animated: Bool) {
        //loadData()
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
                
              if let number  = value!.value(forKey: "PhoneNumber") as? String {
                      self.txtPhoneNumber.text = number
                }
                if let dob = value!.value(forKey: "DOB") as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    
                    if let convertedStartDate = dateFormatter.date(from: dob) {
                        self.pickerDOB.date = convertedStartDate
                    }
                }
              
               
                    if let name = value!.value(forKey: "Name") as? String
                    {
                         self.txtName.text = name
                }
                
                 if let username = value!.value(forKey: "Username") as? String{
                    self.txtUsername.text = username
                }
               if let cpr = value!.value(forKey: "CPR") as? String {
                      self.txtCPR.text = cpr
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

    // MARK: - Table view data source

    @IBAction func updateClicked(_ sender: UIButton) {
        
        sender.isEnabled = false
        let dobFormat = DateFormatter()
        dobFormat.dateFormat = "dd/MM/yyyy"
        var valid = true
        var empty = false
        if txtName.text!.count < 1 || txtUsername.text!.count < 1 || txtPhoneNumber.text!.count < 1 || txtCPR.text!.count < 1{
            empty = false
        }
        if !empty {
            guard self.txtPhoneNumber.text!.isNumeric
                else{
                    valid = false
                    let alert = UIAlertController(title: "Invalid input", message: "Please make sure that fields such as Phone number, CPR are all numeric. s.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
            if(valid && !empty){
                let ref = Database.database().reference().child("User")
                let doctorID = self.id
                ref.child(doctorID!).child("Name").setValue(self.txtName!.text)
                ref.child(doctorID!).child("PhoneNumber").setValue(self.txtPhoneNumber!.text)
                ref.child(doctorID!).child("DOB").setValue(dobFormat.string(from: self.pickerDOB.date))
                ref.child(doctorID!).child("Username").setValue(self.txtUsername!.text)
                ref.child(doctorID!).child("CPR").setValue(self.txtCPR!.text)
                        if pictureChanged == true{
                            var key = Database.database().reference().childByAutoId().key
                            Database.database().reference().child(key!).removeValue()
                            key?.append(".png")
                            let storRef = Storage.storage().reference().child(key!)
                            if self.imgPicture.image?.pngData() != nil {
                                let uploadTask = storRef.putData(self.imgPicture.image!.pngData()!, metadata: nil) { (metadata, error) in
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
    
    @IBAction func changePhotoBtn(_ sender: Any) {
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
        self.imgPicture.image = image
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
