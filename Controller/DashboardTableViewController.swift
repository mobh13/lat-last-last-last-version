//
//  DashboardTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/8/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class DashboardTableViewController: UITableViewController {
    var appointments = [Appointment]()
    var pendingAppoitnments = [Appointment]()
    @IBOutlet weak var lblPendingAppointments: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDAte: UILabel!
    var status = ""
    override func viewDidLoad() {
         navigationItem.hidesBackButton = true
        super.viewDidLoad()
        if let uid = Auth.auth().currentUser?.uid{
            Database.database().reference().child("User").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as! NSDictionary
                self.status = value.value(forKey: "Status") as! String
                self.loadDashboard()
            })
        }
        
    }
    func loadDashboard(){
        if (self.status == "Accepted"){
             self.tabBarController?.tabBar.isHidden = false;
            let ref = Database.database().reference().child("Appointment")
            ref.queryOrdered(byChild: "DoctorID").queryEqual(toValue: (Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                     if let value = snapshot.value as? NSDictionary {
                    let app = Appointment()
                    app.appointmentID = child.key
                    if let stringDate = value.value(forKey: "Date") as? String {
                         app.Date = stringDate.toDate()
                    }
                    if let time = value.value(forKey: "Time") as? String {
                        app.Time = time
                    }
                    if let seekerID = value.value(forKey: "SeekerID") as? String {
                         app.seekerID = seekerID
                    }
                    if let seekerRate = value.value(forKey: "SeekerRate") as? Int {
                        app.seekerRate = seekerRate
                    }
                    if let desc = value.value(forKey: "Description") as? String {
                         app.Description = desc
                    }
                    self.appointments.append(app)
                    }
                }
                self.appointments =  self.appointments.sorted(by: { if($0.Date != $1.Date) {
                    return $0.Date! < $1.Date!
                }else{
                    return $0.Time! < $1.Time!
                    }})
                DispatchQueue.main.async {
                    if(self.appointments.count == 0){
                        self.lblName.text = "There are no upcoming appointments, yet."
                        self.lblDAte.text = ""
                    }else{
                        let seekerID = self.appointments[0].seekerID
                        let ref = Database.database().reference().child("User")
                        ref.child("\(seekerID!)/Name").observeSingleEvent(of: .value, with: { (snapshot) in
                            self.lblName.text = snapshot.value as? String
                            self.tableView.reloadData()
                        })
                        self.lblDAte.text = self.appointments[0].getDateTime()
                    }
                }
            })
            let pendRef = Database.database().reference().child("Appointment")
            pendRef.queryOrdered(byChild: "DoctorID").queryEqual(toValue: (Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                     if let value = snapshot.value as? NSDictionary {
                    let app = Appointment()
                    app.appointmentID = child.key
                    if let date = value.value(forKey: "Date") as? String {
                        app.Date = date.toDate()
                    }
                    if let seekerRate = value.value(forKey: "SeekerRate") as? Int {
                        app.seekerRate = seekerRate
                    }
                    if let desc = value.value(forKey: "Description") as? String {
                        app.Description = desc
                    }
                    self.pendingAppoitnments.append(app)
                    }
                }
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MM-yyyy"
                let date = dateFormatterGet.date(from: Date().description)
                let formatedDate = dateFormatterPrint.string(from: date!)
                self.pendingAppoitnments = self.pendingAppoitnments.filter({
                    if $0.Date! < formatedDate.toDate(){
                        return true
                    }else{
                        return false
                    }
                })
                self.pendingAppoitnments = self.pendingAppoitnments.filter({
                    if $0.seekerRate == nil && $0.Description!.isEmpty {
                        return true
                    }else{
                        return false
                    }
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if(self.pendingAppoitnments.count == 0){
                        self.lblPendingAppointments.text = "You have No pending logs"
                    }else{
                        self.lblPendingAppointments.text = "You have \(self.pendingAppoitnments.count) pending appointments for logs"
                    }
                    self.tableView.reloadData()
                }
            })
        }else if (self.status == "Pending"){
            tableView.isUserInteractionEnabled = false
            tableView.alpha = 0.3
            tableView.backgroundColor = UIColor.gray
            self.tabBarController?.tabBar.isHidden = true;
            let alert = UIAlertController(title: "Wait!", message: "Your account is still pending for approval from the admin. Please allow 2 to 3 business days for the admin to evaluate your request", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Sign Out!", style: .destructive, handler: {action in
                do
                {
                    try Auth.auth().signOut()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Login")
                    self.navigationController!.pushViewController(vc, animated: true)
                }
                catch let error as NSError
                {
                    let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Oh No!", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }))
            self.present(alert, animated: true)
        }else if (self.status == "Rejected"){
            tableView.isUserInteractionEnabled = false
            tableView.alpha = 0.3
             self.tabBarController?.tabBar.isHidden = true;
            tableView.backgroundColor = UIColor.gray
            let alert = UIAlertController(title: "Oh No!", message: "Your account has been rejected by the admins, please you would like to know more information; Pleas contact us on: sanity@sparkdigitus.com", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Sign Out!", style: .destructive, handler: {action in
                do
                {
                    try Auth.auth().signOut()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Login")
                    self.navigationController!.pushViewController(vc, animated: true)
                }
                catch let error as NSError
                {
                    let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Oh No!", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }))
            self.present(alert, animated: true)
        }
    }
    @IBAction func updateSurveyQuestions(_ sender: Any) {
        let s = UIStoryboard(name: "Doctor", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "surveyQuestionList")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    @IBAction func updateQuiz(_ sender: Any) {
        let s = UIStoryboard(name: "Doctor", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "volunteerQuizQuestions")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func setAvaiableTimes(_ sender: Any) {
        let s = UIStoryboard(name: "Doctor", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "setAvaiableTimes")
        self.navigationController!.pushViewController(vc, animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1:
            return 1
        case 2:
            return 3
        default:
            return 1
        }
    }

}
