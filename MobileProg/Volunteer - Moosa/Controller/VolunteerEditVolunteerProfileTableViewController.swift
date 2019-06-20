//
//  EditProfileTableViewController.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/12/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//
import UIKit
import Firebase
import FirebaseStorage

class VolunteerEditVolunteerProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var CPRTextField: UITextField!
    @IBOutlet weak var DOBTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progress: UILabel!
    
    @IBAction func editingUsername(_ sender: Any) {checkEmpty()}
    @IBAction func editingPassword(_ sender: Any) {checkEmpty()}
    @IBAction func editingFullName(_ sender: Any) {checkEmpty()}
    @IBAction func editingPhoneNumber(_ sender: Any) {checkEmpty()}
    @IBAction func editingCPR(_ sender: Any) {checkEmpty()}
    @IBAction func editingDOB(_ sender: Any) {checkEmpty()}
    @IBAction func editingEmail(_ sender: Any) {checkEmpty()}
    
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var baseNSData: NSData?
    
    @IBOutlet var inputFields: [UITextField]!
    
//    var currentVolunteer: String = "LhH2mWFCdPAUvFd0iAn"
    var currentVolunteer: String = ""
    private var datePicker: UIDatePicker?
    var imageSet: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextFieldsTags()
        
        
        self.progress.isHidden = true
        self.progressBar.isHidden = true
        
        if let userID = Auth.auth().currentUser?.uid {
            currentVolunteer = userID
        }
        showDetails()
        getImage()
        
        
        
        
        doneButton.isEnabled = false
        
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        CPRTextField.keyboardType = UIKeyboardType.numberPad
        addDoneButtonOnKeyboard()
        
        
        
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        DOBTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(VolunteerRegisterTableViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VolunteerRegisterTableViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func addTextFieldsTags() {
        var i: Int = 0
        for input in inputFields {
            input.delegate = self
            input.tag = i
            i += 1
        }
        
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        phoneTextField.inputAccessoryView = doneToolbar
        CPRTextField.inputAccessoryView = doneToolbar
        DOBTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        var tag: Int = 0
        var firstResponderTxt: UITextField?
        
        if phoneTextField.isFirstResponder {
            firstResponderTxt = phoneTextField
            tag = phoneTextField.tag
        } else if CPRTextField.isFirstResponder {
            firstResponderTxt = CPRTextField
            tag = CPRTextField.tag
        } else if DOBTextField.isFirstResponder {
            firstResponderTxt = DOBTextField
            tag = DOBTextField.tag
        }
        
        if let textFieldNxt = self.view.viewWithTag(tag+1) as? UITextField {
            textFieldNxt.becomeFirstResponder()
        } else {
            firstResponderTxt?.resignFirstResponder()
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let txtTag:Int = textField.tag
        
        if let textFieldNxt = self.view.viewWithTag(txtTag+1) as? UITextField {
            textFieldNxt.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    @IBAction func imageTapped(_ sender: Any) {
        
        if profileImage.image != nil {
            
            self.baseNSData = self.profileImage.image?.sd_imageData() as NSData?
//            print("This is data", String(describing: self.baseNSData))
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
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
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        //obtaining saving path
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        // let imagePath =
        guard let image = info[.originalImage] as? UIImage else {return}
        self.profileImage.image = image
        checkEmpty()
        imageSet = true
        dismiss(animated: true) {
        }
        print(documentsPath!)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        DOBTextField.text = dateFormatter.string(from: datePicker.date)
        //        view.endEditing(true)
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        Auth.auth().currentUser?.updateEmail(to: emailTextField.text!) { error in
            if error == nil {
                Auth.auth().currentUser?.updatePassword(to: self.passwordTextField.text!) { error in
                    Auth.auth().signIn(withEmail: self.emailTextField.text!,
                                       password: self.passwordTextField.text!)
                    self.editVolunteer()
                    
                    
                }
            } else {
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription , preferredStyle: .alert)
                let nextAction = UIAlertAction(title: "Try Again!", style: .default)
                alert.addAction(nextAction)
                self.present(alert, animated: true)
            }
        }
        
        
    }
    
    func checkEmpty() {
        doneButton.isEnabled = true
        for inputField in inputFields {
            if inputField.text?.isEmpty == true {
                doneButton.isEnabled = false
            }
        }
    }
    
    func editVolunteer() {
        let ref = Database.database().reference()
        ref.child("User/\(currentVolunteer)").child("Username").setValue(self.usernameTextField!.text)
        ref.child("User/\(currentVolunteer)").child("Password").setValue(self.passwordTextField!.text)
        ref.child("User/\(currentVolunteer)").child("Name").setValue(self.fullnameTextField!.text)
        ref.child("User/\(currentVolunteer)").child("PhoneNumber").setValue(self.phoneTextField!.text)
        ref.child("User/\(currentVolunteer)").child("CPR").setValue(self.CPRTextField!.text)
        ref.child("User/\(currentVolunteer)").child("DOB").setValue(self.DOBTextField!.text)
        ref.child("User/\(currentVolunteer)").child("Email").setValue(self.emailTextField!.text)
        
        let imageData: NSData = (self.profileImage.image?.sd_imageData() as NSData?)!
//        print("imageData\(imageData)")
        
        //If these are equal, this means no new image uploaded
        if imageData != baseNSData && imageSet {
            
            var key = Database.database().reference().childByAutoId().key
            Database.database().reference().child(key!).removeValue()
            
            key?.append(".png")
            let storRef = Storage.storage().reference().child(key!)
            let upload = storRef.putData(self.profileImage.image!.pngData()!, metadata: nil) { (metadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Picture Error!", message: "Default picture has been set. "+error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }else{
                    ref.child("User/\(self.currentVolunteer)").child("PicturePath").setValue(key!)
                }
            }
            
            
            
            
            upload.observe(.progress) { snapshot in
                
                self.progress.isHidden = false
                self.progressBar.isHidden = false
                self.profileImage.isHidden = true
                
                let percentComplete = Double(snapshot.progress!.fractionCompleted)
                self.progress.text = String("\(Int(percentComplete * 100))%")
                self.progressBar.setProgress(Float(percentComplete), animated: true)
                
                let alert = UIAlertController(title: "Uploading...", message: "Please Wait", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                
                
                if snapshot.progress!.isFinished {
                    self.progress.isHidden = true
                    self.progressBar.isHidden = true
                    self.profileImage.isHidden = false
                    self.dismiss(animated: false, completion: nil)
                    
                }
                
            }
        }
        
        //        upload.observe(.success, handler: { action in
        //            let alert = UIAlertController(title: "just uplaoded", message: "yes", preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
        //            self.present(alert, animated: true)
        //        })
        
        let alert = UIAlertController(title: "Success", message: "Your details have been edited successfully!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    func showDetails() {
        let ref = Database.database().reference()
        ref.child("User/\(self.currentVolunteer)").observeSingleEvent(of: .value, with: {(snapshot) in
            let dict = snapshot.value as! [String: Any]
            let username = dict["Username"] as! String
            let password = dict["Password"] as! String
            let fullName = dict["Name"] as! String
            let phoneNumber = dict["PhoneNumber"] as! String
            let CPR = dict["CPR"] as! String
            let DOB = dict["DOB"] as! String
            let email = dict["Email"] as! String
            
            
            self.usernameTextField.text = username
            self.passwordTextField.text = password
            self.fullnameTextField.text = fullName
            self.phoneTextField.text = phoneNumber
            self.CPRTextField.text = CPR
            self.DOBTextField.text = DOB
            self.emailTextField.text = email
        }
        )
        
    }
    
    func getImage() {
        let ref = Database.database().reference()
        ref.child("User/\(self.currentVolunteer)").observe(.value, with: {(snapshot) in
            let dict = snapshot.value as! [String: Any]
            let path = dict["PicturePath"] as! String
            let storageRef = Storage.storage().reference().child(path)
            storageRef.downloadURL {
                url, error in
                let image = UIImage(named: "placeholder")
                guard let url = url else { return }
                self.profileImage.sd_setImage(with: url, placeholderImage: image, completed: nil)
                
            }
        }
        )
        
        
    }
    
    // MARK: - Table view data source
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
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
