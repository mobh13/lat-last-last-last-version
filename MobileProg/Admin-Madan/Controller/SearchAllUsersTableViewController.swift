//
//  SearchAllUsersTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/19/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class SearchAllUsersTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var filteredData = [User]()
    var resultSearchController = UISearchController()
    var allUser = [User]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        self.allUser.removeAll()
        let ref = Database.database().reference().child("User")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                if let value = child.value as? NSDictionary{
                    var user = User()
                    if let name = value.value(forKey: "Username") as? String{
                        user.name = name
                    }
                    if let role = value.value(forKey: "Role") as? String{
                        user.role = role
                    }
                    user.id = child.key
                    self.allUser.append(user)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        tableView.reloadData()
    }
 
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData.removeAll(keepingCapacity: false)
            let array = allUser.filter({
                if  $0.name != nil {
                    
                    if ($0.name!.containsIgnoringCase(find: searchText)){
                        return true
                    }else{
                        return false
                    }
                }else{
                    
                    return false
                }
              
            })
            filteredData = array
            self.tableView.reloadData()
            
        
        }
       
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredData.count
        } else {
            return allUser.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        if (resultSearchController.isActive) {
            cell.lbl.text = filteredData[indexPath.row].name
            return cell
        }
        else {
            cell.lbl.text = allUser[indexPath.row].name
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (resultSearchController.isActive) {
            
            let user = self.filteredData[indexPath.row]
            if user.role == "Volunteer" {
                let s = UIStoryboard(name: "Admin", bundle: nil)
                let vc = s.instantiateViewController(withIdentifier: "ShowVolunteerTableViewController") as! ShowVolunteerTableViewController
                
                vc.id = user.id!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if user.role == "Seeker" {
                let s = UIStoryboard(name: "Admin", bundle: nil)
                let vc = s.instantiateViewController(withIdentifier: "ShowSeekerProfileTableViewController") as! ShowSeekerProfileTableViewController
                vc.id = user.id!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if user.role == "Doctor" {
                let s = UIStoryboard(name: "Admin", bundle: nil)
                let vc = s.instantiateViewController(withIdentifier: "DoctorProfileTableViewController") as! AdminDoctorProfileTableViewController
                vc.id = user.id!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let user = self.allUser[indexPath.row]
            if user.role == "Volunteer" {
                let s = UIStoryboard(name: "Admin", bundle: nil)
                let vc = s.instantiateViewController(withIdentifier: "ShowVolunteerTableViewController") as! ShowVolunteerTableViewController
                
                vc.id = user.id!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if user.role == "Seeker" {
                let s = UIStoryboard(name: "Admin", bundle: nil)
                let vc = s.instantiateViewController(withIdentifier: "ShowSeekerProfileTableViewController") as! ShowSeekerProfileTableViewController
                vc.id = user.id!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if user.role == "Doctor" {
                let s = UIStoryboard(name: "Admin", bundle: nil)
                let vc = s.instantiateViewController(withIdentifier: "DoctorProfileTableViewController") as! AdminDoctorProfileTableViewController
                vc.id = user.id!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
     
    }
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
