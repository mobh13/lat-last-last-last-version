//
//  ReportedUserViewTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/2/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

class ReportedUserViewTableViewController: UITableViewController {

    var reports:[Report] = []
    var id:String?
    let db = Database.database().reference()
    var user = User(id: nil, username: nil, email: nil, phone: nil, imgUrl: nil, isBlocked: nil, isReported: nil, name: nil, registrationDate: nil,role: nil)
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
    if self.id != nil {
    self.db.child("User").child(self.id!).observeSingleEvent(of: .value, with: { (snapshot) in
        self.reports.removeAll()
    let value = snapshot.value as? NSDictionary
    self.user.id = self.id!
    
    if let  username = value?.value(forKey: "Username") as? String{
    
    self.user.username = username
    }
    if let  name = value?.value(forKey: "Name") as? String{
    
    self.user.name = name
    }
    if let  imgUrl = value?.value(forKey: "imgUrl") as? String{
    
    self.user.imgUrl = imgUrl
    }
    if let  registrationDate = value?.value(forKey: "RegistrationDate") as? String{
    
    self.user.registrationDate = registrationDate
    }
        if let  role = value?.value(forKey: "Role") as? String{
            
            self.user.role = role
        }
    
    
    })
        
        let query = db.child("Report").queryOrdered(byChild: "User").queryEqual(toValue: self.id!)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if  let val = snapshot.value as? NSDictionary{
                for key in (val.keyEnumerator()){
                    if  let row = val.value(forKey: key as! String) as? NSDictionary{
                        
                        let id = key as! String
                        if let date = row.value(forKey: "Date") as? String{
                            let report = Report(id: id, date: date, by: nil, byUsername: nil, reason:nil)
                            self.reports.append(report)
                        }
                        
                      
                    }}
                self.tableView.reloadData()
                
            }})
        
        
    }
    
    DispatchQueue.main.async {
    self.tableView.reloadData()
    
    }
    
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 5
        }else {
            
          return  reports.count
        }

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            if(indexPath == IndexPath(row: 0, section: 0)){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "userPhotoCell", for: indexPath) as! ReportedUserUserImgCell
                cell.img = nil
                
                return cell
                
            }
            if(indexPath == IndexPath(row: 1, section: 0)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsCell", for: indexPath) as! ReportedUserUserInfoCell
                cell.title.text = "Name"
                cell.value.text = self.user.name
                return cell
                
            }
            if(indexPath == IndexPath(row: 2, section: 0)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsCell", for: indexPath) as! ReportedUserUserInfoCell
                cell.title.text = "Username"
                if let u = self.user.username{
                    cell.value.text = "@\(u)"

                }
                return cell
            }
            if(indexPath == IndexPath(row: 3, section: 0)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsCell", for: indexPath) as! ReportedUserUserInfoCell
                cell.title.text = "Role"
                cell.value.text = self.user.role
                return cell
            }
            if(indexPath == IndexPath(row: 4, section: 0)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsCell", for: indexPath) as! ReportedUserUserInfoCell
                cell.title.text = "Registration Date"
                cell.value.text = self.user.registrationDate
                return cell
            }
            
        }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportedUserReportCell
            let report = reports[indexPath.row]
            cell.lbl.text = report.date
            return cell
            
        }
    
return UITableViewCell()
        

      
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            let s = UIStoryboard(name: "Admin", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "ReportTableViewController") as! ReportTableViewController
            vc.id = reports[indexPath.row].id
            
            self.navigationController?.pushViewController(vc, animated: true)
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
