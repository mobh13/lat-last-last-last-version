//
//  DoctorSettingsTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/8/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication
class DoctorSettingsTableViewController: UITableViewController {

    @IBAction func btnDeleteAccount(_ sender: Any) {
        let myContext = LAContext()
        let myLocalizedReasonString = "Please use touch or face ID to make sure that you want to delete your account."
        var authError: NSError?
    
        let user = Auth.auth().currentUser
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString, reply: { success, evaluateError in
                    DispatchQueue.main.async {
                        if success {
                        let alert = UIAlertController(title: "Warning!", message: "If you delete your account, all of your information will be removed from the system and you will have to sign up again if you wished to use the application.", preferredStyle: .alert)
                        let nextAction = UIAlertAction(title: "Delete Account!", style: .destructive) { action in
                                                        user?.delete { error in
                        if error != nil {
                            let alerterror = UIAlertController(title: "Error!", message: "There has been an error in the deleting your account.", preferredStyle: .alert)
                            let actionError = UIAlertAction(title: "Okay!", style: .default)
                                                                alerterror.addAction(actionError)
                                                                self.present(alerterror, animated: true)
                            } else {
                                let alertdone = UIAlertController(title: "Success!", message: "Your account has been deleted successfully.", preferredStyle: .alert)
                                let actionDone = UIAlertAction(title: "Okay!", style: .default) {
                                                                    action in
                                let s = UIStoryboard(name: "Main", bundle: nil)
                                let vc = s.instantiateViewController(withIdentifier: "Login")
                                                                    vc.navigationItem.hidesBackButton = true
                                self.navigationController!.pushViewController(vc, animated: true)
                                                                }
                                alertdone.addAction(actionDone)
                                self.present(alertdone, animated: true)
                                                            }
                                                        }
                                                    }
                                alert.addAction(nextAction)
                                let goBackAction = UIAlertAction(title: "Go Back!", style: .default, handler: nil)
                                alert.addAction(goBackAction)
                                self.present(alert, animated: true)
                        } else {
                            if let error = evaluateError {
                                let alerterror = UIAlertController(title: "Error!", message: error.localizedDescription , preferredStyle: .alert)
                                let actionError = UIAlertAction(title: "Okay!", style: .default)
                                alerterror.addAction(actionError)
                                self.present(alerterror, animated: true)
                            }
                        }
                    }
                })
            } else {
                if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                    myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString, reply: { success, evaluateError in
                        DispatchQueue.main.async {
                            if success {
                                let alert = UIAlertController(title: "Warning!", message: "If you delete your account, all of your information will be removed from the system and you will have to sign up again if you wished to use the application.", preferredStyle: .alert)
                                let nextAction = UIAlertAction(title: "Delete Account!", style: .destructive) { action in
                                    user?.delete { error in
                                        if error != nil {
                                            let alerterror = UIAlertController(title: "Error!", message: "There has been an error in the deleting your account.", preferredStyle: .alert)
                                            let actionError = UIAlertAction(title: "Okay!", style: .default)
                                            alerterror.addAction(actionError)
                                            self.present(alerterror, animated: true)
                                        } else {
                                            let alertdone = UIAlertController(title: "Success!", message: "Your account has been deleted successfully.", preferredStyle: .alert)
                                            let actionDone = UIAlertAction(title: "Okay!", style: .default) {
                                                action in
                                                let s = UIStoryboard(name: "Main", bundle: nil)
                                                let vc = s.instantiateViewController(withIdentifier: "Login")
                                                vc.navigationItem.hidesBackButton = true
                                                self.navigationController!.pushViewController(vc, animated: true)
                                            }
                                            alertdone.addAction(actionDone)
                                            self.present(alertdone, animated: true)
                                        }
                                    }
                                }
                                alert.addAction(nextAction)
                                let goBackAction = UIAlertAction(title: "Go Back!", style: .default, handler: nil)
                                alert.addAction(goBackAction)
                                self.present(alert, animated: true)

                            }else{
                                if let error = evaluateError {
                                    let alerterror = UIAlertController(title: "Error!", message: error.localizedDescription , preferredStyle: .alert)
                                    let actionError = UIAlertAction(title: "Okay!", style: .default)
                                    alerterror.addAction(actionError)
                                    self.present(alerterror, animated: true)
                                }
                            }
                        }
                    }
                )}
            }
        } else {
            print("Ooops!!.. This feature is not supported.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let s = UIStoryboard(name: "Doctor", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "repotedUsersList")
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
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
