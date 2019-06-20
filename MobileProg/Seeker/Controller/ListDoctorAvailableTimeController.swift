//
//  ListDoctorAvailableTimeController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/19/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import  Firebase

class ListDoctorAvailableTimeController: UITableViewController {
    
    var userId = ""
    var avaiableTimes = [Avaiabletime]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("AvaibaleTimes")
        ref.queryOrdered(byChild: "DoctorID").queryEqual(toValue: self.userId).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                let value = child.value as! NSDictionary
                let obj = Avaiabletime()
                if let appointmentDate = value.value(forKey: "Date") as? String {
                    obj.date = appointmentDate
                }
                if let appointmentDocID = value.value(forKey: "DoctorID") as? String {
                    obj.docID = appointmentDocID
                }
                if let appointmentFrom = value.value(forKey: "From") as? String {
                    obj.from = appointmentFrom
                }
                if let appointmentTo = value.value(forKey: "To") as? String {
                    obj.to = appointmentTo
                }
                self.avaiableTimes.append(obj)
            }
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MM-yyyy"
            let date = dateFormatterGet.date(from: Date().description)
            let formatedDate = dateFormatterPrint.string(from: date!)
            self.avaiableTimes = self.avaiableTimes.filter({
                if $0.date!.toDate() < formatedDate.toDate(){
                    return true
                }else{
                    return false
                }
            })
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "avaiableTimeCell", for: indexPath) as! ListDoctorAvailableTimesCell
        cell.lblDate.text = self.avaiableTimes[indexPath.row].date
        cell.lblTo.text = self.avaiableTimes[indexPath.row].to
        cell.lblfrom.text = self.avaiableTimes[indexPath.row].from
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title : "Sure?",message: "Are you sure you want to select this appointment date?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            let appDic = [
                "Date" : self.avaiableTimes[indexPath.row].date!,
                "Time" : self.avaiableTimes[indexPath.row].from!,
                "DoctorID" : self.avaiableTimes[indexPath.row].docID!,
                "Description" : "",
                "DoctorRate:" : 0,
                "SeekerID" : Auth.auth().currentUser?.uid as? String,
                "SeekerRate" : 0
                ] as [String : Any]
            Database.database().reference().child("Appointment").childByAutoId().setValue(appDic)
            let success = UIAlertController(title : "Success",message: "Your appointment has been set successfully.", preferredStyle: .alert)
            success.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
            self.present(success, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
