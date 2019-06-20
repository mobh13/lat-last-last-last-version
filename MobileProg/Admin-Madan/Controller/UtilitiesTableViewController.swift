//
//  UtilitiesTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/4/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import FirebaseAuth
class UtilitiesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.navigationItem.title = "Utilities"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SendNotificationTableViewController") as! SendNotificationTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "EditAccountTableViewController") as! EditAccountTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            
           let alert =  UIAlertController(title: "Logout?", message: "Are you Sure that you want to logout ?", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {(alert: UIAlertAction!) in self.singOut()}))
                 alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert,animated: true)

        default:
            print("problem with the code the selected row is not configured ")
        }
        
    }

    func singOut(){
        
        do{
            try Auth.auth().signOut()
            let s = UIStoryboard(name: "Main", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "MainScreen") 
            
            
            self.navigationController?.pushViewController(vc, animated: true)
      
        }catch{
            print("error signing out !!")
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
