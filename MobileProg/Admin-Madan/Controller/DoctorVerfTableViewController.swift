//
//  DoctorVerfTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/2/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class DoctorVerfTableViewController: UITableViewController {

    var verfObj:VerficationRequest = VerficationRequest(id: nil, userId: nil, note: nil, personalPicture: nil, coursePicture: nil, academicPicture: nil,status: nil)
    var id:String?
    var user:User = User(id: nil, username: nil, email: nil, phone: nil, imgUrl: nil, isBlocked: nil, isReported: nil,name: nil,registrationDate: nil,role: nil)
    let db = Database.database().reference()

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
            
            
        })
            db.child("AuthenticateRequest").child(self.id!).observeSingleEvent(of: .value, with:  { (snapshot) in
                if  let val = snapshot.value as? NSDictionary{
           
                            
                    if let note = val.value(forKey: "note") as? String{
                        self.verfObj.note = note

                    }
                    if  let academicPicture = val.value(forKey: "academicPicture") as? String {
                        self.verfObj.academicPicture = academicPicture

                    }
                   if let personalPicture = val.value(forKey: "personalPicture") as? String {
                    self.verfObj.personalPicture  = personalPicture

                    }
                    if let status = val.value(forKey: "status") as? String{
                        self.verfObj.status = status

                    }
                    if let coursePicture = val.value(forKey: "coursePicture") as? String{
                        self.verfObj.coursePicture = coursePicture

                        
                    }
                            self.verfObj.id = self.id!
                    

                      
                
                    self.tableView.reloadData()
                    
                }
                   self.tableView.reloadData()
            })
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
            return 4
        }else {
            var count = 0
            if self.verfObj.academicPicture != nil {
                count = count + 1
            }
            if self.verfObj.personalPicture != nil {
                count = count + 1
            }
            if self.verfObj.coursePicture != nil {
                count = count + 1
            }

            return  count
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            if(indexPath == IndexPath(row: 0, section: 0)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "userPhotoCell", for: indexPath) as! ReportedUserUserImgCell
                if let i = self.user.imgUrl{
                    cell.img.kf.setImage(with: URL(string:i))
                }
                
                
                return cell
                
            }
            if(indexPath == IndexPath(row: 1, section: 0)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsCell", for: indexPath) as! ReportedUserUserInfoCell
                cell.title.text = "Name"
                if let name = self.user.name{
                  cell.value.text = name
                }
                
                return cell
                
            }
            if(indexPath == IndexPath(row: 2, section: 0)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsCell", for: indexPath) as! ReportedUserUserInfoCell
                cell.title.text = "Username"
                if let username = self.user.username {
                   cell.value.text = "@\(username)"
                }
                
                return cell
            }
            if(indexPath == IndexPath(row: 3, section: 0)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsCell", for: indexPath) as! ReportedUserUserInfoCell
                cell.title.text = "Regestration Date"
                if let regDate = self.user.registrationDate {
                    cell.value.text = regDate
                }
                return cell
            }
         
            
        }else{
        
            if(indexPath == IndexPath(row: 0, section: 1)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportedUserReportCell
                
               
                if  self.verfObj.academicPicture != nil{
                    cell.lbl.text = "Academic Certification Picture"
                }
                return cell
            }
            if(indexPath == IndexPath(row: 1, section: 1)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportedUserReportCell
                
                
                if  self.verfObj.personalPicture != nil {
                    cell.lbl.text = "Personal Picture"
                }
                return cell
            }
            if(indexPath == IndexPath(row: 2, section: 1)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportedUserReportCell
                
                
                if  self.verfObj.coursePicture != nil {
                    cell.lbl.text = "Course Picture"
                }
                return cell
            }

            
        }
        
        return UITableViewCell()
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            var name:String?
            var url:String?
            if(indexPath == IndexPath(row: 0, section: 1)){
              url  = self.verfObj.academicPicture
                name = "Academic Certificate Picture"
                
            }
            if(indexPath == IndexPath(row: 1, section: 1)){
                url  = self.verfObj.personalPicture
                name = "Personal Picture"
            }
            if(indexPath == IndexPath(row: 2, section: 1)){
                url  = self.verfObj.coursePicture
                name = "Course Certificate Picture"
            }
            let s = UIStoryboard(name: "Admin", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "DoctorDocumentTableViewController") as! DoctorDocumentTableViewController
            
            vc.name  = name
            vc.url = url
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func updateStatus(_ status:String) {
       db.child("AuthenticateRequest").child(self.id!).child("status").setValue(status)
    }
    
    @IBAction func acceptClicked(_ sender: Any) {
        updateStatus("Accepted")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func rejectClicked(_ sender: Any) {
        updateStatus("Rejected")
        self.navigationController?.popViewController(animated: true)

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
