//
//  EditSeekerTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/13/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class EditSeekerTableViewController: UITableViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var id:String?
    var pictureChanged = false
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtUsername:UITextField!
    @IBOutlet weak var txtCPR: UITextField!
    @IBOutlet weak var pickerDOB: UIDatePicker!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.delegate = self
        txtPhone.delegate = self
        txtCPR.delegate = self
        txtUsername.delegate = self
         self.progressBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
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
                
              if let number = value!.value(forKey: "PhoneNumber") as? String {
                       self.txtPhone.text = number
                }
                
                if let name = value!.value(forKey: "Name") as? String {
                    self.txtName.text = name
                }
                if let dob = value!.value(forKey: "DOB") as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    
                    if let convertedStartDate = dateFormatter.date(from: dob) {
                        self.pickerDOB.date = convertedStartDate
                    }
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
    @IBAction func btnSave(_ sender: Any) {
        let dobFormat = DateFormatter()
        dobFormat.dateFormat = "dd/MM/yyyy"
        var valid = true
        var empty = false
        if txtName.text!.count < 1 || txtUsername.text!.count < 1 || txtPhone.text!.count < 1 || txtCPR.text!.count < 1{
            empty = false
        }
        if !empty {
            guard self.txtPhone.text!.isNumeric
               else{
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


                
                 ref.child(doctorID!).child("PhoneNumber").setValue(self.txtPhone!.text)
                
                 ref.child(doctorID!).child("Username").setValue(self.txtUsername!.text)
                ref.child(doctorID!).child("DOB").setValue(dobFormat.string(from: self.pickerDOB.date))
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
                }}
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
}
