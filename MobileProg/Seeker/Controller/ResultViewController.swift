//
//  ResultViewController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/18/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    var result :Float?
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDone(_ sender: Any) {
        let s = UIStoryboard(name: "Seeker", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "ListUsers") as! SeekerListUsersTableViewController
        switch self.result!{
        case Float(exactly: 0.0)! ... Float(exactly: 13.5)! :
            vc.type = "Volunteer"
        default:
            vc.type = "Doctor"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.lblResult.text=" Your Result : "
        self.lblCounter.text = "\(result!)"
        let points:Float = result!
        switch points {
        case Float(exactly: 0)! ... Float(exactly: 7.5)! :
            self.lblDescription.text = "Mild mood disturbance "
        case 8 ... 13.5:
            self.lblDescription.text = " Moderate stress "
        case 14.0 ... 20.0:
            self.lblDescription.text = "Serious stress "
        default:
            print("error")
        }
    }
}
