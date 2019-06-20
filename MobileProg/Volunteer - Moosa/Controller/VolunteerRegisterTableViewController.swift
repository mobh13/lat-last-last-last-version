//
//  VolunteerRegisterTableViewController.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/11/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage


class VolunteerRegisterTableViewController: UITableViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var CPRTextField: UITextField!
    @IBOutlet weak var DOBTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBAction func editingUsername(_ sender: Any) {checkEmpty()}
    @IBAction func editingPassword(_ sender: Any) {checkEmpty()}
    @IBAction func editingFullName(_ sender: Any) {checkEmpty()}
    @IBAction func editingPhoneNumber(_ sender: Any) {checkEmpty()}
    @IBAction func editingCPR(_ sender: Any) {checkEmpty()}
    @IBAction func editingDOB(_ sender: Any) {checkEmpty()}
    @IBAction func editingEmail(_ sender: Any) {checkEmpty()}
    
    
    
    private var currentVolunteer = VolunteerVolunteer(username: "", email: "", password: "", fullName: "", phoneNumber: "", CPRNumber: "", DOB: "", picturePath: "")
    
    var picIsDefault: Bool = true
    
    
    
    
    
    @IBOutlet weak var registerButton: UIButton!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextFieldsTags()
        getDefaultPic()
        
        registerButton.isEnabled = false
        
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        CPRTextField.keyboardType = UIKeyboardType.numberPad
        addDoneButtonOnKeyboard()

        
        

        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        DOBTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(VolunteerRegisterTableViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VolunteerRegisterTableViewController.viewTapped(gestureRecognizer:)))

        
        view.addGestureRecognizer(tapGesture)
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(VolunteerRegisterTableViewController.registerVolunteer))

        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    
    func getDefaultPic() {
        let storageRef = Storage.storage().reference().child("profilepic.png")
        storageRef.downloadURL {
            url, error in guard let url = url else { return }
            self.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: nil)
        }
    }
    
    
    @IBAction func imageClicked(_ sender: Any) {
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
    
    
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: self.emailTextField.text!,
                                   password: self.passwordTextField.text!)
                self.registerVolunteer()
            } else {
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription , preferredStyle: .alert)
                let nextAction = UIAlertAction(title: "Try Again!", style: .default)
                alert.addAction(nextAction)
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBOutlet var inputFields: [UITextField]!
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        DOBTextField.text = dateFormatter.string(from: datePicker.date)
//        view.endEditing(true)
    }
    
    func checkEmpty() {
        registerButton.isEnabled = true
        for inputField in inputFields {
            if inputField.text?.isEmpty == true {
                registerButton.isEnabled = false
            }
        }
    }
    
    func registerVolunteer() {
//        print("Registered!")
//        let ref = Database.database().reference()
//        ref.child("Volunteer").observe(.value, with: {(snapshot) in
//            if let result = snapshot.children.allObjects as? [DataSnapshot] {
//                for child in result {
//                    let volunteerID = child.key as String //get autoID
//                    ref.child("Volunteer/\(volunteerID)/id").observe(.value, with: { (snapshot) in
//                        if let id = snapshot.value as? Int {
//                            //change this ID and put current uid
//                            if id == 1 {
//                                ref.child("Volunteer/\(volunteerID)").child("username").setValue(self.usernameTextField!.text)
//                                ref.child("Volunteer/\(volunteerID)").child("password").setValue(self.passwordTextField!.text)
//                                ref.child("Volunteer/\(volunteerID)").child("fullName").setValue(self.fullnameTextField!.text)
//                                ref.child("Volunteer/\(volunteerID)").child("phoneNumber").setValue(self.phoneTextField!.text)
//                                ref.child("Volunteer/\(volunteerID)").child("CPRNumber").setValue(self.CPRTextField!.text)
//                                ref.child("Volunteer/\(volunteerID)").child("DOB").setValue(self.DOBTextField!.text)
//                                ref.child("Volunteer/\(volunteerID)").child("email").setValue(self.emailTextField!.text)
//
//
//
//                            }
//                        }
//                    })
//                }
//            }
//        })
        
        var imagePath: String
        
        if picIsDefault == false {
            imagePath = Database.database().reference().child("User").childByAutoId().key!
            imagePath.append(".png")
        } else {
            imagePath = "profilepic.png"
        }
        
        
        
        guard let volunteer = VolunteerVolunteer(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, fullName: fullnameTextField.text!, phoneNumber: phoneTextField.text!, CPRNumber: CPRTextField.text!, DOB: DOBTextField.text!, picturePath: imagePath) else {
            fatalError("Unable to instantiate this volunteer")
        }
        
        currentVolunteer = volunteer
        
        
//
//        let db = Database.database().reference().child("Volunteer");
//        let key = db.childByAutoId().key
//        let volunteerDB = ["id": key!,
//                     "CPRNumber": volunteer.CPRNumber,
//                     "DOB": volunteer.DOB,
//                     "email": volunteer.email,
//                     "fullName": volunteer.fullName,
//                     "password": volunteer.password,
//                     "phoneNumber": volunteer.phoneNumber,
//                     "username": volunteer.username
//        ]
//
//        db.child(key!).setValue(volunteerDB)
//
//        let alert = UIAlertController(title: "Success", message: "You have successfully signed up to the applicaiton as a volunteer.", preferredStyle: .alert)
//        self.present(alert, animated: true)
        
        performSegue(withIdentifier: "showQuiz", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuiz" {
            if let destinationVC = segue.destination as? VolunteerQuizQuestionsTableViewController {
                destinationVC.currentVolunteer = currentVolunteer
                destinationVC.userImage = userImage
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        //obtaining saving path
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        // let imagePath =
        guard let image = info[.originalImage] as? UIImage else {return}
        self.userImage.image = image
        dismiss(animated: true) {
        }
        checkEmpty()
        picIsDefault = false
        print(documentsPath!)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
