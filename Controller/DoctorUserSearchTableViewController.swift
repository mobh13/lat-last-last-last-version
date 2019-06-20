//
//  DoctorUserSearchTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/11/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class DoctorUserSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    var filteredData = [SeekersSearch]()
    var resultSearchController = UISearchController()
    var allSeekers = [SeekersSearch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allSeekers.removeAll()
        let ref = Database.database().reference().child("User")
        ref.queryOrdered(byChild: "Role").queryEqual(toValue: "Seeker").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                if let value = child.value as? NSDictionary{
                    let seeker = SeekersSearch()
                    if let name = value.value(forKey: "Name") as? String{
                         seeker.name = name
                    }
                    seeker.uid = child.key
                    self.allSeekers.append(seeker)
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
        
        // Reload the table
        tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filteredData.removeAll(keepingCapacity: false)
            let array = allSeekers.filter({
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
            return allSeekers.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeekerNameCell", for: indexPath) as! DoctorUserSearchTableViewCell
        if (resultSearchController.isActive) {
             cell.lblResultName.text = filteredData[indexPath.row].name
            return cell
        }
        else {
             cell.lblResultName.text = allSeekers[indexPath.row].name
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if resultSearchController.isActive {
            let s = UIStoryboard(name: "Doctor", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "viewOthersProfile") as! OtherUsersProfileTableViewController
            vc.userID = self.filteredData[indexPath.row].uid!
            self.navigationController!.pushViewController(vc, animated: true)
        }else{
            let s = UIStoryboard(name: "Doctor", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "viewOthersProfile") as! OtherUsersProfileTableViewController
            vc.userID = self.allSeekers[indexPath.row].uid!
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}
