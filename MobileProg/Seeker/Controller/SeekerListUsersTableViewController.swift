//
//  ListUsersTableViewController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/18/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase




class SeekerListUsersTableViewController: UITableViewController {
    
    

    var allUsers = [User2]()
    var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.allUsers.removeAll()
        let ref = Database.database().reference().child("User")
        ref.queryOrdered(byChild: "Role").queryEqual(toValue : type).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            
            
            self.allUsers.removeAll()
            if  let val = snapshot.value as? NSDictionary{
                for key in (val.keyEnumerator()){
                    if  let row = val.value(forKey: key as! String) as? NSDictionary{
                        
                        let id = key as! String
                        
                        let user = User2()
                        if let name = row.value(forKey: "Name") as? String{
                            user.name = name
                            
                        }
                        user.uid = id
                        self.allUsers.append(user)
                        
                        
                        
                    }}
                self.tableView.reloadData()
                
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      
            return allUsers.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
     
            cell.Name.text = allUsers[indexPath.row].name
            return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = UIStoryboard(name: "Seeker", bundle: nil)
        
        if (type == "Volunteer"){
            
            let vc = s.instantiateViewController(withIdentifier: "SeekerViewVouluteerProfile") as! SeekerviewVolunteerProfileController
            vc.userID = self.allUsers[indexPath.row].uid!
            self.navigationController!.pushViewController(vc, animated: true)
            
            
        }else{
            let vc = s.instantiateViewController(withIdentifier: "SeekerViewDoctorProfile") as! SeekerViewDoctorProfileTableViewController
            vc.userId = self.allUsers[indexPath.row].uid!
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}
