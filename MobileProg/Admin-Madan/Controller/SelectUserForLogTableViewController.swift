//
//  SelectUserForLogTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/29/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class SelectUserForLogTableViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet weak var filter: UISegmentedControl!
    
    var data:[User] = []
    let db =  Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        loadData()
    }

    func loadData(){
        
        if filter.selectedSegmentIndex == 0 {
           
            self.db.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
                self.data.removeAll()

                let value = snapshot.value as? NSDictionary
                
                for key in (value?.keyEnumerator())!{
                    let row = value?.value(forKey: key as! String)
                    if  let nonNil = row as? NSDictionary {
                        let id = key as! String
                        if let username = nonNil.value(forKey: "Username") as? String,
                        let isBlocked = nonNil.value(forKey: "IsBlocked") as? Bool
                        {
                            let user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: nil)
                            
                            self.data.append(user)
                            
                        }
                        
                       
                        
                        
                        
                        
                    }
                }
                
                self.tableView.reloadData()
                
            })


        }else if filter.selectedSegmentIndex == 1 {
            
            
                    let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Doctor")
                    query.observeSingleEvent(of: .value, with: { (snapshot) in
                        self.data.removeAll()

                        if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                            let id = key as! String
                                if let username = row.value(forKey: "Username") as? String,
                                    let isBlocked = row.value(forKey: "IsBlocked") as? Bool
                                {
                                    let user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: nil)
                                    
                                    self.data.append(user)
                                    
                                }
                            }}
                    self.tableView.reloadData()
                        
                        }})
            

            
        } else if filter.selectedSegmentIndex == 2 {
               data = []
            let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Volunteer")
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                self.data.removeAll()

                if  let val = snapshot.value as? NSDictionary{
                    for key in (val.keyEnumerator()){
                        if  let row = val.value(forKey: key as! String) as? NSDictionary{
                            
                            let id = key as! String
                            if let username = row.value(forKey: "Username") as? String,
                                let isBlocked = row.value(forKey: "IsBlocked") as? Bool
                            {
                                let user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: nil)
                                
                                self.data.append(user)
                                
                            }
                        }}
                    self.tableView.reloadData()
                    
                }})
         

            
        }else if filter.selectedSegmentIndex == 3 {
            data = []
            let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Seeker")
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                self.data.removeAll()

                if  let val = snapshot.value as? NSDictionary{
                    for key in (val.keyEnumerator()){
                        if  let row = val.value(forKey: key as! String) as? NSDictionary{
                            
                            let id = key as! String
                            if let username = row.value(forKey: "Username") as? String,
                                let isBlocked = row.value(forKey: "IsBlocked") as? Bool
                            {
                                let user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: nil)
                                
                                self.data.append(user)
                                
                            }
                        }}
                    self.tableView.reloadData()
                    
                }})

            
        }
        tableView.reloadData()

    }
    // MARK: - Table view data source

    
    @IBAction func filterChangedIndex(_ sender: Any) {
        
        loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell

        cell.lbl.text = data[indexPath.row].username
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = UIStoryboard(name: "Admin", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "SelectLogFoUserTableViewController") as! SelectLogFoUserTableViewController
        vc.userID = data[indexPath.row].id
        
        self.navigationController?.pushViewController(vc, animated: true)
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
