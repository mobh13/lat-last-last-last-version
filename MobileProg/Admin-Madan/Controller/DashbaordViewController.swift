//
//  DashbaordViewController.swift
//  MobileProg
//
//  Created by MobileProg on 4/29/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class DashbaordViewController: UIViewController {

    @IBOutlet weak var lblRow6: UILabel!
    @IBOutlet weak var lblRow5: UILabel!
    @IBOutlet weak var lblRow4: UILabel!
    @IBOutlet weak var lblRow3: UILabel!
    @IBOutlet weak var lblRow2: UILabel!
    @IBOutlet weak var lblRow1: UILabel!
     let db = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Dashboard"
        loadData()
    }

    func loadData(){
        
        let seekersQuery = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Seeker")
        seekersQuery.observeSingleEvent(of: .value, with: { (snapshot) in
      
            var counter = 0
            if  let val = snapshot.value as? NSDictionary{
                for key in (val.keyEnumerator()){
                   
                    counter = counter + 1
 
                    }}
                self.lblRow1.text = "\(counter) Registerd Seekers"
                
            })
        let volunteersQuery = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Volunteer")
        volunteersQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var counter = 0
            if  let val = snapshot.value as? NSDictionary{
                for key in (val.keyEnumerator()){
                    
                    counter = counter + 1
                    
                }}
            self.lblRow2.text = "\(counter) Registerd Volunteers"
            
        })
        let doctorsQuery = db.child("User").queryOrdered(byChild: "Role").queryEqual(toValue: "Doctor")
        doctorsQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var counter = 0
            if  let val = snapshot.value as? NSDictionary{
                for key in (val.keyEnumerator()){
                    
                    counter = counter + 1
                    
                }}
            self.lblRow3.text = "\(counter) Registerd Doctors"
            
        })
        self.db.child("Appointment").observeSingleEvent(of: .value, with: { (snapshot) in
             var counter = 0
            let value = snapshot.value as? NSDictionary
            
            for key in (value?.keyEnumerator())!{
               
                    
                    
                       counter = counter + 1
                    
                    
                    
                }
              self.lblRow4.text = "\(counter) Appointments"
            }
            
          
            
        )
  
        self.db.child("SessionLog").observeSingleEvent(of: .value, with: { (snapshot) in
            var counter = 0
            let value = snapshot.value as? NSDictionary
            
            for key in (value?.keyEnumerator())!{
                
                
                
                counter = counter + 1
                
                
                
            }
            self.lblRow5.text = "\(counter) Sessions"
        }
            
            
            
        )
        let authQuery = db.child("AuthenticateRequest").queryOrdered(byChild: "status").queryEqual(toValue: "Pending")
        authQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var counter = 0
            if  let val = snapshot.value as? NSDictionary{
                for key in (val.keyEnumerator()){
                    
                    counter = counter + 1
                    
                }}
            self.lblRow6.text = "\(counter) Pending \n Authuntication Requests"
            
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
