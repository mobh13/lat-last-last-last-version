//  DoctorAuthenticationTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 06/02/19
//  Copyright © 2019 polytechnic.bh. All rights reserved

import UIKit
import Firebase
import FirebaseStorage

class DoctorAuthenticationTableViewController: UITableViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate{
   
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var exitOutlet: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var coursePicture: UIImageView!
    @IBOutlet weak var academicPicture: UIImageView!
    @IBOutlet weak var personalPicture: UIImageView!
    @IBOutlet weak var txtViewNotes: UITextView!
    var personalPicturePath : String?
     var academicPicturePath : String?
     var coursePicturePath : String?
    var numOfUploads = 0
    var btnTag = 0
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        txtViewNotes.delegate = self
        self.progressBar.transform = CGAffineTransform(scaleX: 1, y: 4)
         self.navigationItem.setHidesBackButton(true, animated: false)
        txtViewNotes.delegate = self
        txtViewNotes.text = "Please enter here any notes for the admins related to the images provided above"
        txtViewNotes.textColor = UIColor.lightGray
        txtViewNotes.isEditable = true;
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        guard self.personalPicture.image != nil,
        self.academicPicture.image != nil,
        self.coursePicture.image != nil else {
            let alert = UIAlertController(title: "Empty!", message: "Please make sure that all images have a selection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        let db = Database.database().reference().child("AuthenticateRequest");
        if self.txtViewNotes.textColor == UIColor.lightGray {
            self.txtViewNotes.text = " "
        }
        sender.isEnabled = false
        self.exitOutlet.isEnabled = false
        self.personalPicturePath =  upload(self.personalPicture.image!)
        self.academicPicturePath =  upload(self.academicPicture.image!)
        self.coursePicturePath =  upload(self.coursePicture.image!)
        let key = Auth.auth().currentUser?.uid
        let docDB = ["DoctorID": key!,
                     "PersonalPicture": self.personalPicturePath!,
                     "AcademicPicture": self.academicPicturePath!,
                     "CoursePicture": self.coursePicturePath!,
                     "Notes": txtViewNotes.text!
            ] as [String : Any]
        db.child(key!).setValue(docDB){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                let alert = UIAlertController(title: "Error!", message: "Data could not be saved: \(error).", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                sender.isEnabled = true
                self.exitOutlet.isEnabled = true
                return
            } else {
                Database.database().reference().child("User").child("\(key!)/PicturePath").setValue(self.personalPicturePath)
            }
        }
    }
    
     func upload(_ image: UIImage) -> String{
        var key = Database.database().reference().childByAutoId().key
        Database.database().reference().child(key!).removeValue()
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
        uploadTask.observe(.progress) { snapshot in
            self.progressBar.progress = Float(snapshot.progress!.fractionCompleted)
        }
        uploadTask.observe(.success) { (snapshot) in
            self.numOfUploads += 1
            self.lblProgress.text = "\(self.numOfUploads) out of 3"
            if self.numOfUploads == 3 {
                let alert = UIAlertController(title: "Success!", message: "Data saved successfully but please keep the internet connection avaiable on the device for at leat one minute to ensure all data is sent.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in  let s = UIStoryboard(name: "Doctor", bundle: nil)
                    let vc = s.instantiateViewController(withIdentifier: "Dashboard")
                    self.navigationController!.pushViewController(vc, animated: true)}))
                self.present(alert, animated: true)
            }
        }
        return key!
    }

    @IBAction func btnExit(_ sender: Any) {
        let s = UIStoryboard(name: "Main", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "Login")
        vc.navigationItem.hidesBackButton = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func choosePicture(_ sender: UIButton) {
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
        self.btnTag = sender.tag
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let image = info[.originalImage] as? UIImage else {return}
        if btnTag == 1 {
            self.personalPicture.image = image
        } else if btnTag == 2 {
            self.academicPicture.image = image
        }else if btnTag == 3 {
            self.coursePicture.image = image
        }
        dismiss(animated: true) {
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter here any notes for the admins related to the images provided above"
            textView.textColor = UIColor.lightGray
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0,4:
            return 1
        case 1,2,3,6,5:
            return 2
        default:
            return 1
        }
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
