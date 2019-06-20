//
//  ViewController.swift
//  MobileProg
//
//  Created by MobileProg on 4/29/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func helpSeekerClicked(_ sender: Any) {
        let s = UIStoryboard(name: "Seeker", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "SeekerSignUp")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func volunteerClicked(_ sender: Any) {
                let s = UIStoryboard(name: "Volunteer", bundle: nil)
                                let vc = s.instantiateViewController(withIdentifier: "volunteerRegister")
                                self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doctorClicked(_ sender: Any) {
        let s = UIStoryboard(name: "Doctor", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "doctorSignup") as! DoctorSignupTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

