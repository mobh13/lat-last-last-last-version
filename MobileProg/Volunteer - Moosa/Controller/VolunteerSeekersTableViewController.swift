//
//  SeekersTableViewController.swift
//  MobileProg
//
//  Created by Moosa Hammad on 6/9/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class VolunteerSeekersTableViewController: UITableViewController, UISearchBarDelegate {
    
    var seekers = [VolunteerSeeker]()
    var allSeekers = [VolunteerSeeker]()
    var selectedSeeker: VolunteerSeeker?
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSeekers()
        setUpSearchBar()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setUpSearchBar() {
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    
    //Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { self.seekers = self.allSeekers
            self.tableView.reloadData(); return }
        self.seekers = self.allSeekers.filter({seeker -> Bool in
            return seeker.username.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    private func loadSeekers() {
        self.seekers.removeAll()
        let ref = Database.database().reference().child("User")
        let query = ref
        query.observe(.value, with: {(snapshot) in for childSnapshot in snapshot.children {
            print(childSnapshot)
            let childSnap = childSnapshot as! DataSnapshot
            let dict = childSnap.value as! [String: Any]
            let role = dict["Role"] as? String ?? "-"
            

            
            if role == "Seeker" {
                
                
                
            let email = dict["Email"] as? String ?? "-"
            let isReported = dict["IsReported"] as? Bool ?? false
            let name = dict["Name"] as? String ?? "-"
            let picturePath = dict["PicturePath"] as? String ?? "-"
            let username = dict["Username"] as? String ?? "-"
            let phoneNumber = dict["PhoneNumber"] as? String ?? "-"
            let requestedVolunteer = dict["RequestedVolunteer"] as? String ?? "-"
            let id = String(childSnap.key)



                guard let seeker = VolunteerSeeker(email: email, isReported: isReported, name: name, picturePath: picturePath, role: role, username: username, phoneNumber: phoneNumber, requestedVolunteer: requestedVolunteer, seekerId: id) else {
                fatalError("Unable to instantiate this material")
            }
            self.seekers += [seeker]
            self.allSeekers = self.seekers


            }
            }
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.navigationItem.title = "Seekers";
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.seekers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cellIdentifier = "SeekerViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VolunteerSeekerTableViewCell else {
            fatalError("The dequeued cell is not an instance of ReadingMaterialTableViewCell.")
        }
        
        let seeker = self.seekers[indexPath.row]
        
        cell.nameLabel.text = seeker.username
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSeeker = self.seekers[indexPath.row]
        let refreshAlert = UIAlertController(title: "Start Session", message: "Are you sure you want to start a session with " + selectedSeeker!.username + "?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //Do something
            self.performSegue(withIdentifier: "showSeekerDetails", sender: nil)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //Do nothing
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSeekerDetails" {
            if let destinationVC = segue.destination as? VolunteerSeekerDetailsTableViewController {
                destinationVC.selectedSeeker = selectedSeeker
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
