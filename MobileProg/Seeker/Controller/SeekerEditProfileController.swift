//
//  SeekerEditProfileController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/17/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController{
    func hidKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard () {
        view.endEditing(true)
    }
}
class SeekerEditProfileController: UITableViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextFieldDelegate
{

        var gender : String! = ""
    
        @IBOutlet var txtInputs: [UITextField]!
        @IBOutlet weak var pictureView: UIImageView!
        @IBOutlet weak var txtName: UITextField!
        @IBOutlet weak var txtCPR: UITextField!
        @IBOutlet weak var txtNumber: UITextField!
        @IBOutlet weak var txtEmail: UITextField!
        @IBOutlet weak var dOB: UIDatePicker!
        @IBOutlet weak var txtpassword: UITextField!
        @IBOutlet weak var progressBar: UIProgressView!
        var imageChanged = false
    
   
    @IBAction func gender(_ sender: Any) {
            let index = (sender as AnyObject).selectedSegmentIndex
            switch index {
                case 1:
                    gender = "Female"
                default:
                    gender = "Male"
            }
        }
    
    @IBAction func btnExit(_ sender: Any) {
    
    
    }
    

    override func viewDidLoad() {
            super.viewDidLoad()
            self.hidKeyboard()
            self.progressBar.isHidden = true
            txtCPR.delegate = self
            txtName.delegate = self
            txtEmail.delegate = self
            txtNumber.delegate  = self
            txtpassword.delegate = self
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

    // MARK: - Table view data source
    @IBAction func PromptPicture(_ sender: UIButton) {
        
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
    @IBAction func btnSave(_ sender: UIButton) {
            var valid = true
        
            var empty=false
        for textField in self.txtInputs{
                    if !textField.hasText{
                            empty = true
                            }
            
                if empty {
                            guard self.txtNumber.text!.isNumeric,
                                self.txtCPR.text!.isNumeric else{
                        
                                    valid = false
                                    let alert = UIAlertController(title: "Invalid input", message: "Please make sure that fields such as Phone number, CPR are all numeric. And if they are, make sure you have the same password in both fields.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                                    self.present(alert, animated: true)
                                    return
                }
                if (valid && !empty){
                        let ref = Database.database().reference()
                        let seekerID = Auth.auth().currentUser?.uid
                        ref.child("User/\(seekerID!)").child("Name").setValue(self.txtName!.text)
                        ref.child("User/\(seekerID!)").child("Gender").setValue(self.gender)
                        ref.child("User/\(seekerID!)").child("CPR").setValue(self.txtCPR!.text)
                        ref.child("User/\(seekerID!)").child("PhoneNumber").setValue(self.txtName!.text)
                    
                    Auth.auth().currentUser?.updateEmail(to: self.txtEmail!.text!, completion: nil)
                    ref.child("User/\(seekerID!)").child("Email").setValue(self.txtEmail!.text)
                    if self.txtpassword.hasText{
                            Auth.auth().currentUser?.updatePassword(to: self.txtpassword!.text!, completion: nil)
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
                                    
                                        let alert = UIAlertController(title: "Picture Error!", message: "Default picture has been set. "+error!.localizedDescription, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                                        self.present(alert, animated: true)
                                    Database.database().reference().child("User/\(seekerID!)").child("PicturePath").setValue("profilepic.png")
                                    return
                                }else{
                                    sender.isEnabled = true
                                    Database.database().reference().child("User/\(seekerID!)").child("PicturePath").setValue(key!)
                                }
                            }
                            uploadTask.observe(.progress) { snapshot in
                                    self.progressBar.progress = Float(snapshot.progress!.fractionCompleted)                        }
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
}
    
    
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  9
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
   
        switch section {
        case 0,1,2,3,4,5,6,7:
            return 1
        case 8:
           return 2
        default:
            return 1
            
        }
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
