//
//  AppointmentTableViewController.swift
//  MobileProg
//
//  Created by Abudlla Ali on 6/8/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class AppointmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let s = UIStoryboard(name: "Doctor", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "upcomingAppointment")
            self.navigationController!.pushViewController(vc, animated: true)
        case 1:
            let s = UIStoryboard(name: "Doctor", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "pastAppointments")
            self.navigationController!.pushViewController(vc, animated: true)
        case 2:
            let s = UIStoryboard(name: "Doctor", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "appointmentsLogs")
            self.navigationController!.pushViewController(vc, animated: true)
        default:
            print("error at: \(indexPath.row)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
}
