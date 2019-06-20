//
//  UsersTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/31/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let all = IndexPath(row: 0, section: 0)
        let search = IndexPath(row: 1, section: 0)
        let blocked = IndexPath(row: 2, section: 0)
        let reported = IndexPath(row: 3, section: 0)
        let doctors = IndexPath(row: 0, section: 1)
        let s = UIStoryboard(name: "Admin", bundle: nil)
        
        
        if indexPath == all {
            let vc = s.instantiateViewController(withIdentifier: "ListUsersTableViewController") as! ListUsersTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath == search {
            let vc = s.instantiateViewController(withIdentifier: "searchAllUsers") as! SearchAllUsersTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath == blocked{
            let vc = s.instantiateViewController(withIdentifier: "ListUsersTableViewController") as! ListUsersTableViewController
            vc.speacial = "Blocked"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath == reported{
            let vc = s.instantiateViewController(withIdentifier: "ListUsersTableViewController") as! ListUsersTableViewController
             vc.speacial = "Reported"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath == doctors{
            let vc = s.instantiateViewController(withIdentifier: "doctorsTableViewController") as! doctorsTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Users"
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
