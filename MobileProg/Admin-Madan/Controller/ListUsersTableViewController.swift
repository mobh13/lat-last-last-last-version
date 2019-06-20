//
//  ListUsersTableViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 5/31/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class ListUsersTableViewController: UITableViewController{
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var filter: UISegmentedControl!
    var data:[User] = []
    var filterd:[User] = []
    var speacial:String?
    let db =  Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if speacial != nil && speacial != "Blocked" {
            addBtn.isEnabled = false
            addBtn.tintColor = .clear
        }

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
        data.removeAll()
        if speacial == nil {
            if filter.selectedSegmentIndex == 0 {
                
                self.db.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
                    self.data.removeAll()
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                let id = key as! String
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                }
                            }}
                        self.tableView.reloadData()
                    }
                })
            }else if filter.selectedSegmentIndex == 1 {
                
                
                let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Doctor")
                query.observeSingleEvent(of: .value, with: { (snapshot) in
                    self.data.removeAll()
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                                let id = key as! String
                                
                                
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                    
                                }
                                
                                
                                
                            }}
                        self.tableView.reloadData()
                        
                    }})
                
                
                
            } else if filter.selectedSegmentIndex == 2 {
                
                let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Volunteer")
                query.observeSingleEvent(of: .value, with: { (snapshot) in
                    self.data.removeAll()
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                                let id = key as! String
                                
                                
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                    
                                }
                                
                                
                                
                            }}
                        self.tableView.reloadData()
                        
                    }})
                
                
                
            }else if filter.selectedSegmentIndex == 3 {
                
                let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Seeker")
                query.observeSingleEvent(of: .value, with: { (snapshot) in
                    self.data.removeAll()
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                                let id = key as! String
                                
                                
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                    
                                }
                                
                                
                                
                            }}
                        self.tableView.reloadData()
                        
                    }})
                
                
            }
            
            
        }else if speacial == "Blocked" {
            if filter.selectedSegmentIndex == 0 {
                
                self.db.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
                    self.data.removeAll()
                    
                    
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                                let id = key as! String
                                
                                
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                    
                                }
                                
                                
                                
                            }}
                        self.data = self.data.filter{
                            
                            if $0.isBlocked == true {
                                
                                return true
                            }else{
                                return false
                            }
                            
                            
                        }
                        self.tableView.reloadData()
                        
                    }
                    
                    
                })
                
                
            }else if filter.selectedSegmentIndex == 1 {
                
                
                let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Doctor")
                query.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    self.data.removeAll()
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                                let id = key as! String
                                
                                
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                    
                                }
                                
                                
                                
                            }}
                        self.data = self.data.filter{
                            
                            if $0.isBlocked == true {
                                
                                return true
                            }else{
                                return false
                            }
                            
                            
                        }
                        self.tableView.reloadData()
                    }
                    
                    
                    
                }
                )
                
                
                
            } else if filter.selectedSegmentIndex == 2 {
                
                let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Volunteer")
                query.observeSingleEvent(of: .value, with: { (snapshot) in
                    self.data.removeAll()
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                                let id = key as! String
                                
                                
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                    
                                }
                                
                                
                                
                            }}
                        self.data = self.data.filter{
                            
                            if $0.isBlocked == true {
                                
                                return true
                            }else{
                                return false
                            }
                            
                            
                        }
                        self.tableView.reloadData()
                        
                    }
                    
                    
                    
                    
                })
                
                
                
            }else if filter.selectedSegmentIndex == 3 {
                
                let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Seeker")
                query.observeSingleEvent(of: .value, with: { (snapshot) in
                    self.data.removeAll()
                    
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                                let id = key as! String
                                let username = row.value(forKey: "Username") as! String
                                let isBlocked = row.value(forKey: "IsBlocked") as! Bool
                                let role = row.value(forKey: "Role") as! String
                                
                                let user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                self.data.append(user)
                            }}
                        self.data = self.data.filter{
                            
                            if $0.isBlocked == true {
                                
                                return true
                            }else{
                                return false
                            }
                            
                            
                        }
                        self.tableView.reloadData()
                        
                    }})
                
                
            }
            
            
            
        }else if speacial == "Block" {
            
            if filter.selectedSegmentIndex == 0 {
                
                self.db.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
                    self.data.removeAll()
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                                let id = key as! String
                                
                                
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                    
                                }
                                
                                
                                
                            }}
                        self.tableView.reloadData()
                        
                    }
                    self.data = self.data.filter{
                        
                        if $0.isBlocked == false {
                            
                            return true
                        }else{
                            return false
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
                                
                                
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                    
                                }
                                
                                
                                
                            }}
                        self.data = self.data.filter{
                            
                            if $0.isBlocked == false {
                                
                                return true
                            }else{
                                return false
                            }
                            
                            
                        }
                        self.tableView.reloadData()
                        
                    }
                    
                    
                    
                })
                
                
                
            } else if filter.selectedSegmentIndex == 2 {
                
                let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Volunteer")
                query.observeSingleEvent(of: .value, with: { (snapshot) in
                    self.data.removeAll()
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                                let id = key as! String
                                
                                
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                    
                                }
                                
                                
                                
                            }}
                        self.data = self.data.filter{
                            
                            if $0.isBlocked == false {
                                
                                return true
                            }else{
                                return false
                            }
                            
                            
                        }
                        self.tableView.reloadData()
                        
                    }
                    
                    
                })
                
                
                
            }else if filter.selectedSegmentIndex == 3 {
                
                let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Seeker")
                query.observeSingleEvent(of: .value, with: { (snapshot) in
                    self.data.removeAll()
                    if  let val = snapshot.value as? NSDictionary{
                        for key in (val.keyEnumerator()){
                            if  let row = val.value(forKey: key as! String) as? NSDictionary{
                                
                                let id = key as! String
                                
                                
                                if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String {
                                    var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: nil ,name: nil,registrationDate: nil,role: role)
                                    self.data.append(user)
                                    
                                }
                                
                                
                                
                            }}
                        self.data = self.data.filter{
                            
                            if $0.isBlocked == false {
                                
                                return true
                            }else{
                                return false
                            }
                            
                            
                        }
                        self.tableView.reloadData()
                        
                    }
                   
                    
                })
            
            
        }
        
    }else if speacial == "Reported" {
    if filter.selectedSegmentIndex == 0 {
    
    self.db.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
    self.data.removeAll()
        if  let val = snapshot.value as? NSDictionary{
            for key in (val.keyEnumerator()){
                if  let row = val.value(forKey: key as! String) as? NSDictionary{
                    
                    let id = key as! String
                    
                    
                    if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String, let  isReported = row.value(forKey: "IsReported") as? Bool {
                        var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: isReported ,name: nil,registrationDate: nil,role: role)
                        self.data.append(user)
                        
                    }
                    
                    
                    
                }}
       
            self.data = self.data.filter{
                
                if $0.isReported == true {
                    
                    return true
                }else{
                    return false
                }
                
                
            }
            self.tableView.reloadData()
            
            
        }
    
    })
    
    
    }else if filter.selectedSegmentIndex == 1 {
    
    
    let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Doctor")
    query.observeSingleEvent(of: .value, with: { (snapshot) in
        self.data.removeAll()

        if  let val = snapshot.value as? NSDictionary{
            for key in (val.keyEnumerator()){
                if  let row = val.value(forKey: key as! String) as? NSDictionary{
                    
                    let id = key as! String
                    
                    
                    if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String, let isReported = row.value(forKey: "IsReported") as? Bool {
                        var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: isReported ,name: nil,registrationDate: nil,role: role)
                        self.data.append(user)
                        
                    }
                    
                    
                    
                }}
            
            self.data = self.data.filter{
                
                if $0.isReported == true {
                    
                    return true
                }else{
                    return false
                }
                
                
            }
            self.tableView.reloadData()
            
            
        }
    })
    
    
    
    } else if filter.selectedSegmentIndex == 2 {
    
    let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Volunteer")
    query.observeSingleEvent(of: .value, with: { (snapshot) in
    self.data.removeAll()
        if  let val = snapshot.value as? NSDictionary{
            for key in (val.keyEnumerator()){
                if  let row = val.value(forKey: key as! String) as? NSDictionary{
                    
                    let id = key as! String
                    
                    
                    if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String, let isReported = row.value(forKey: "IsReported") as? Bool {
                        var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: isReported ,name: nil,registrationDate: nil,role: role)
                        self.data.append(user)
                        
                    }
                    
                    
                    
                }}
            
            self.data = self.data.filter{
                
                if $0.isReported == true {
                    
                    return true
                }else{
                    return false
                }
                
                
            }
            self.tableView.reloadData()
            
            
        }})
    
    
    
    }else if filter.selectedSegmentIndex == 3 {
    
    let query = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Seeker")
    query.observeSingleEvent(of: .value, with: { (snapshot) in
    self.data.removeAll()
    
        if  let val = snapshot.value as? NSDictionary{
            for key in (val.keyEnumerator()){
                if  let row = val.value(forKey: key as! String) as? NSDictionary{
                    
                    let id = key as! String
                    
                    
                    if let username = row.value(forKey: "Username") as? String, let isBlocked = row.value(forKey: "IsBlocked") as? Bool, let role = row.value(forKey: "Role") as? String, let isReported = row.value(forKey: "IsReported") as? Bool {
                        var user = User(id: id, username: username, email: nil, phone: nil, imgUrl: nil, isBlocked: isBlocked,isReported: isReported ,name: nil,registrationDate: nil,role: role)
                        self.data.append(user)
                        
                    }
                    
                    
                    
                }}
            
            self.data = self.data.filter{
                
                if $0.isReported == true {
                    
                    return true
                }else{
                    return false
                }
                
                
            }
            self.tableView.reloadData()
            
            
        }})
    
    
    }
    
    
    
    }
    
    tableView.reloadData()
    
}




override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
}
@IBAction func filterClicked(_ sender: Any) {
    loadData()
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
  
        return data.count
    
}
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
    
  
       cell.lbl.text = data[indexPath.row].username
          return cell
    
}
@IBAction func addBtnClicked(_ sender: Any) {
    if let s = speacial , s == "Blocked"{
        let s = UIStoryboard(name: "Admin", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "ListUsersTableViewController") as! ListUsersTableViewController
        vc.speacial = "Block"
        
        self.navigationController?.pushViewController(vc, animated: true)
    } else if speacial == nil {
        let alert = UIAlertController(title: "What Kind of User ?", message: "Select the Type of User You want to add !!", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Seeker", style: .default, handler: {(action ) in
            
            let s = UIStoryboard(name: "Admin", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "AddSeekerTableViewController")
            
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Doctor", style: .default, handler: {(action ) in
            
            let s = UIStoryboard(name: "Admin", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "AddDoctorTableViewController")
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Volunteer", style: .default, handler: {(action ) in
            
            let s = UIStoryboard(name: "Admin", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "AddVolunteerTableViewController")
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        self.present(alert,animated: true)
        // add the code to view add user view
    }
    
    
    
}
override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    if let s = speacial , s == "Blocked" {
        let action = UIContextualAction(style: .normal, title: "Unblock",
                                        handler: { (action, view, completionHandler) in
                                            // Update data source when user taps action
                                            let uid = self.data[indexPath.row].id!
                                            self.db.child("User").child(uid).child("IsBlocked").setValue(false)
                                            self.loadData()
                                            
                                            completionHandler(true)
        })
        
        action.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [action])
    }else if let s = speacial , s == "Block" {
        let action = UIContextualAction(style: .normal, title: "Block",
                                        handler: { (action, view, completionHandler) in
                                            // Update data source when user taps action
                                            let uid = self.data[indexPath.row].id!
                                            self.db.child("User").child(uid).child("IsBlocked").setValue(true)
                                            self.loadData()
                                            completionHandler(true)
        })
        
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }else{
        return nil
    }
}

override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    if let s = speacial , s == "Blocked" {
        return .none
    }else if  speacial == "Block" || speacial == "Reported" {
        return .none
    }else{
        return .delete
    }
}
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    if speacial == "Reported" {
 
            let s = UIStoryboard(name: "Admin", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "ReportedUserViewTableViewController") as! ReportedUserViewTableViewController
            vc.id = self.data[indexPath.row].id
            
            self.navigationController?.pushViewController(vc, animated: true)
        
    }else{

            let user = self.data[indexPath.row]
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



// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        
        //           deleteUser(indexPath.row)
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        var user = self.data[indexPath.row]
        db.child("User").child(user.id!).removeValue()
        loadData()
        
        
    }
}


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
