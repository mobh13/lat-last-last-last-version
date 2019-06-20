import UIKit
import Firebase

class UpcomingAppointmentsTableViewController: UITableViewController {
    var appointments = [Appointment]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("Appointment")
        ref.queryOrdered(byChild: "DoctorID").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                if let value = child.value as? NSDictionary {
                    let app = Appointment()
                    if let date = value.value(forKey: "Date") as? String {
                        app.Date = date.toDate()
                    }
                    if let time = value.value(forKey: "Time") as? String {
                        app.Time = time
                    }
                    if let seekerID = value.value(forKey: "SeekerID") as? String {
                        app.seekerID = seekerID
                    }
                    self.appointments.append(app)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if(self.appointments.count == 0){
                    let alert = UIAlertController(title: "No Appointments", message: "you have no upcoming appointments.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay!", style: .default){action in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alert, animated: true)
                }
            }
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MM-yyyy"
            let date = dateFormatterGet.date(from: Date().description)
            let formatedDate = dateFormatterPrint.string(from: date!)
            self.appointments = self.appointments.filter({
                if $0.Date! > formatedDate.toDate(){
                    return true
                }else{
                    return false
                }
            })
            self.appointments =  self.appointments.sorted(by:
                { if($0.Date != $1.Date) {
                return $0.Date! < $1.Date!
            }else{
                return $0.Time! < $1.Time!
                }})
        })
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appointments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upComingAppointmentCell", for: indexPath) as! UpComingAppointmentTableViewCell
        let ref = Database.database().reference().child("User")
        ref.child("\(self.appointments[indexPath.row].seekerID!)/Name").observeSingleEvent(of: .value, with: { (snapshot) in
            cell.lblName.text  = (snapshot.value as? String)!
        })
        cell.lblDateTime.text = appointments[indexPath.row].getDateTime()
        return cell
    }
}
