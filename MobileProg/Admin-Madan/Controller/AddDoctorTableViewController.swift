//
//  AddDoctorTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/16/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class AddDoctorTableViewController: UITableViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCPR: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtClinicName: UITextField!
    @IBOutlet weak var txtSpc: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtBlock: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtBuilding: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var picture: UIImageView!
    var inputs:[UITextField] = []
    var pictureChanged = false
    override func viewDidLoad() {
        super.viewDidLoad()
         self.progressBar.isHidden = true
        txtName.delegate = self
        txtUsername.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtCPR.delegate = self
        txtClinicName.delegate = self
        txtSpc.delegate = self
        txtCity.delegate = self
        txtBlock.delegate = self
        txtStreet.delegate = self
        txtBuilding.delegate = self
            self.inputs = [txtName,txtUsername,txtEmail,txtPassword,txtCPR,txtNumber,txtClinicName,txtSpc,txtCity,txtBlock,txtStreet,txtBuilding]
    }
    @IBAction func changeBtnPress(_ sender: Any) {
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
        self.picture.image = image
        self.pictureChanged = true
        dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.pictureChanged = false
    }
    @IBAction func addClicked(_ sender: Any) {
        var valid = true
        var empty = false
        for textField in self.inputs {
            if !textField.hasText {
                empty = true
            }
        }
        if !empty {
            guard self.txtCPR.text!.isNumeric,
                self.txtNumber.text!.isNumeric,
                self.txtBlock.text!.isNumeric,
                self.txtStreet.text!.isNumeric,
                self.txtBuilding.text!.isNumeric else{
                    valid = false
                    let alert = UIAlertController(title: "Invalid input", message: "Please make sure that fields such as Phone number, CPR, clinc's block / street / block are all numeric.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return}
            }else{
                let alert = UIAlertController(title: "Error", message: "All fields required", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert,animated: true)
            }
            if(valid && !empty){
              
                Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { user, error in
                    if error == nil {
                        
                        let key = user!.user.uid
                        let date = Date()
                        let format = DateFormatter()
                        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let formattedDate = format.string(from: date)
                      
                        
                        let db = Database.database().reference().child("User");
                        
                        let dbOb = ["Name": self.txtName.text!,
                                    "PhoneNumber": self.txtNumber.text!,
                                    "Email" :  self.txtEmail.text! ,
                                    "PicturePath": " ",
                                    "IsBlocked" : false,
                                    "IsReported" : false,
                                    "Role" : "Doctor",
                                    "Username" : self.txtUsername.text!,
                                    "Speciality": self.txtSpc.text!,
                                    "Status": "Pending",
                                    "ClincStreet": self.txtStreet.text!,
                                    "ClincName": self.txtClinicName.text!,
                                    "ClincCity": self.txtCity.text!,
                                    "ClincBuilding": self.txtBuilding.text!,
                                    "ClincBlock": self.txtBlock.text!,
                                    "CPR": self.txtCPR.text!,
                                    "RegistrationDate" : formattedDate
                            ] as [String : Any]
                        
                        db.child(key).setValue(dbOb)
                        if self.pictureChanged == true{
                            var pictureKey = Database.database().reference().childByAutoId().key
                            Database.database().reference().child(pictureKey!).removeValue()
                            pictureKey?.append(".png")
                            let storRef = Storage.storage().reference().child(pictureKey!)
                            if self.picture.image?.pngData() != nil {
                                let uploadTask = storRef.putData(self.picture.image!.pngData()!, metadata: nil) { (metadata, error) in
                                    if error != nil {
                                        let alert = UIAlertController(title: "Picture Error!", message: "Default picture has been set. "+error!.localizedDescription, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                                        db.child(key).child("PicturePath").setValue("profilepic.png")
                                        self.present(alert, animated: true)
                                        return
                                    }else{
                                        db.child(key).child("PicturePath").setValue(pictureKey!)
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
                                    }))
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
                    }else{
                        
                        let alert = UIAlertController(title: "Error", message: "Error adding user  !!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {(action) in
                            
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert,animated: true)
                        
                    }
                
            }
            }
    }
}
    

