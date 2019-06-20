//
//  SeekerSignUpTableViewController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/11/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage






class SeekerSignUpTableViewController: UITableViewController
, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    var gender : String! = ""
    var numOfUploads = 0
    
    @IBOutlet weak var personalPicture: UIImageView!
    @IBOutlet var txtInputs: [UITextField]!
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtCPR: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass2: UITextField!
    @IBOutlet weak var txtDOB: UIDatePicker!
    @IBOutlet weak var txtPass: UITextField!
    var imageChanged = false
    var personalPicturePath: String?
    
    @IBAction func genderSelected(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            gender = "Female"
        case 1:
            gender = "Male"
        default:
            gender = "Male"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        var valid = true
        var empty = false
        
        for textFiled in self.txtInputs {
            if !textFiled.hasText{
                empty = true
            }
        }
        
        
        if (!empty) {
            guard self.txtCPR.text!.isNumeric,
                self.txtPhone.text!.isNumeric,
                self.txtPass.text!.elementsEqual( self.txtPass2.text!)
                else {
                    valid = false
                    let alert = UIAlertController(title : "Invalid input",message: "Please make sure that fields such as Phone number, CPR are all numeric.Also make sure you have the same password in both fields.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                    
            }
        }
        if (valid && !empty ){
            
            
            Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPass.text!){ user, error in
                if error == nil {
                    
                    let seeker = Seeker()
                    seeker.name = self.txtName.text
                    seeker.gender = self.gender
                    seeker.CPR = self.txtCPR.text!
                    seeker.email = self.txtEmail.text
                    seeker.password = self.txtPass.text
                    seeker.phoneNumber = self.txtPhone.text!
                    seeker.DOB = ""
                    
                    let db = Database.database().reference().child("User");
                    
                    sender.isEnabled = false
                    if (self.personalPicture.image != nil){
                        self.personalPicturePath =  self.upload(self.personalPicture.image!)
                    }else{
                        self.personalPicturePath = "profilepic.png"
                    }
                    
                    let date = Date()
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let formattedDate = format.string(from: date)
                    let key = Auth.auth().currentUser?.uid
                    let seekerObj = ["seekerID":key!,
                                     "name" : seeker.name!,
                                     "gender": seeker.gender!,
                                     "CPR": seeker.CPR!,
                                     "email": seeker.email!,
                                     "phoneNumber": seeker.phoneNumber!,
                                     "DOB": seeker.DOB!,
                                     "picturePath" :self.personalPicturePath!,
                                     "IsBlocked" : false,
                                     "IsReported" : false,
                                     "Role" : "Seeker",
                                     "RegistrationDate" : formattedDate ] as [String : Any]
                    
                    
                    db.child(key!).setValue(seekerObj)
                    let alert = UIAlertController(title: "Success", message: "You have successfully signed up to the applicaiton.", preferredStyle: .alert)
                    alert.addAction(   UIAlertAction(title: "Next!", style: .default) { action in
                        let s = UIStoryboard(name: "Seeker", bundle: nil)
                        let vc = s.instantiateViewController(withIdentifier: "SeekerProfile")
                        self.navigationController!.pushViewController(vc, animated: true)
                    })
                    self.present(alert, animated: true, completion:nil)
                    
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Please make sure that all fields contain valid information information (No Empty fields / Numeric values only in (CPR,PhoneNumber))", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go Back!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    func upload(_ image: UIImage) -> String{
        var key = Database.database().reference().childByAutoId().key
        Database.database().reference().child("USER").child(key!).removeValue()
        key?.append(".png")
        let ref = Storage.storage().reference().child(key!)
        let uploadTask = ref.putData(image.pngData()!, metadata: nil) { (metadata, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.numOfUploads = 1
            
            if self.numOfUploads == 1{
                let alert = UIAlertController(title: "Success!", message: "Image saved successfully but please keep the internet connection avaiable on the device for at leat one minute to ensure all data is sent.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in  let s = UIStoryboard(name: "Seeker", bundle: nil)
                    let vc = s.instantiateViewController(withIdentifier: "Dashboard")
                    self.navigationController!.pushViewController(vc, animated: true)}))
                self.present(alert, animated: true)
            }
        }
        return key!
    }
    
    @IBAction func btnExitClicked(_ sender: UIButton) {
        let s = UIStoryboard(name: "Main", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "Login")
        vc.navigationItem.hidesBackButton = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    @IBAction func btnUploadClicked(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
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
        
        self.personalPicture.image = image
        dismiss(animated: true) {
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
