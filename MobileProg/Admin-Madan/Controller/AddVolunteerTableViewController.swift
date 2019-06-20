//
//  AddVolunteerTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/16/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class AddVolunteerTableViewController: UITableViewController ,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var pickerDOB: UIDatePicker!
    @IBOutlet weak var txtCPR: UITextField!
    var pictureChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressBar.isHidden = true
        txtName.delegate = self
        txtEmail.delegate = self
        txtUsername.delegate = self
        txtPassword.delegate = self
        txtPhone.delegate = self
        txtCPR.delegate = self
}
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }

    @IBAction func changePicture(_ sender: Any) {
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
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    @IBAction func addClicked(_ sender: UIButton) {
        
        guard txtName.text!.count > 1 , txtEmail.text!.count > 1, txtUsername.text!.count > 1, txtPassword.text!.count > 1 , txtPhone.text!.count > 1 else{
            let alert = UIAlertController(title: "Error", message: "All fields required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert,animated: true)
            return
        }
        sender.isEnabled = false
        Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { user, error in
            if error == nil {
                
                let key = user!.user.uid
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formattedDate = format.string(from: date)
                let dobFormat = DateFormatter()
                dobFormat.dateFormat = "dd/MM/yyyy"
                let user = User(id: key, username: self.txtUsername.text!, email: self.txtEmail.text!, phone: self.txtPhone.text!, imgUrl: nil, isBlocked: nil, isReported: nil, name: self.txtName.text!, registrationDate: formattedDate, role: "Seeker")
                let db = Database.database().reference().child("User")
                if self.pictureChanged == true {
                    var pictureKey = Database.database().reference().childByAutoId().key
                    Database.database().reference().child(pictureKey!).removeValue()
                    pictureKey?.append(".png")
                    let storRef = Storage.storage().reference().child(pictureKey!)
                    if self.picture.image?.pngData() != nil {
                        let uploadTask = storRef.putData(self.picture.image!.pngData()!, metadata: nil) { (metadata, error) in
                            if error != nil {
                                let alert = UIAlertController(title: "Picture Error!", message: "Default picture has been set. "+error!.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                                let dbOb = ["Name": user.name!,
                                            "PhoneNumber": user.phone!,
                                            "Email" :  user.email! ,
                                            "CPR" : self.txtCPR.text!,
                                            "PicturePath": "profilepic.png",
                                            "DOB": dobFormat.string(from: self.pickerDOB.date) ,
                                            "IsBlocked" : false,
                                            "IsReported" : false,
                                            "Role" : "Volunteer",
                                            "Username" : user.username!,
                                            "RegistrationDate" : formattedDate
                                    ] as [String : Any]
                                db.child(key).setValue(dbOb)
                                self.present(alert, animated: true)
                                return
                            }else{
                                let dbOb = ["Name": user.name!,
                                            "PhoneNumber": user.phone!,
                                            "Email" :  user.email! ,
                                            "CPR" : self.txtCPR.text!,
                                            "PicturePath": pictureKey!,
                                            "DOB": dobFormat.string(from: self.pickerDOB.date) ,
                                            "IsBlocked" : false,
                                            "IsReported" : false,
                                            "Role" : "Volunteer",
                                            "Username" : user.username!,
                                            "RegistrationDate" : formattedDate
                                    ] as [String : Any]
                                db.child(key).setValue(dbOb)
                            }
                        }
                        uploadTask.observe(.progress) { snapshot in
                            self.progressBar.isHidden = false
                            self.progressBar.progress = Float(snapshot.progress!.fractionCompleted)
                            self.changeBtn.isHidden = true
                        }
                        uploadTask.observe(.success) { (snapshot) in
                            sender.isEnabled = true
                            let alert = UIAlertController(title: "Success!!", message: "Your information has been successfully updated on our servers.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { action in
                                DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                                }
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }else{
                    let alert = UIAlertController(title: "Success!", message: "Your information has been successfully updated on our servers.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { action in
                        DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                        }
                    }))
                    self.present(alert, animated: true)
                }
            }else{
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription , preferredStyle: .alert)
                let nextAction = UIAlertAction(title: "Try Again!", style: .default)
                alert.addAction(nextAction)
                self.present(alert, animated: true)
            }
        }
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
}
