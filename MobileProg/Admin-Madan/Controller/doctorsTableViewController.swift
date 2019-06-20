//
//  doctorsTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/31/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class doctorsTableViewController: UITableViewController,UISearchBarDelegate {

    var data:[User] = []
    let db =  Database.database().reference()

    @IBOutlet weak var searchbar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        searchbar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        loadData()
    }

    // MARK: - Table view data source

   
    func loadData(){
      
            
        let query = db.child("AuthenticateRequest").queryOrdered(byChild: "status").queryEqual(toValue: "Pending")
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            self.data.removeAll()

            if  let val = snapshot.value as? NSDictionary{
                for key in (val.keyEnumerator()){
                    if  let row = val.value(forKey: key as! String) as? NSDictionary{
                        print(key)
                        let id = key as! String
                        self.db.child("User").child(id).observeSingleEvent(of: .value, with: {(snapshot) in
                              let value = snapshot.value as? NSDictionary
                            if  let username = value?.value(forKey: "Username") as? String{
                                let user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: nil,isReported: nil ,name: nil,registrationDate: nil,role: nil)
                                self.data.append(user)
                            }
                     
                            self.tableView.reloadData()
                             })
                    }}
              
                self.tableView.reloadData()
                
            }})
            
        
        tableView.reloadData()
        
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
        let user = self.data[indexPath.row]
        cell.lbl.text = user.username
     
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = UIStoryboard(name: "Admin", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "DoctorVerfTableViewController") as! DoctorVerfTableViewController
          let user = self.data[indexPath.row]
        vc.id = user.id
        self.navigationController?.pushViewController(vc, animated: true)
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
