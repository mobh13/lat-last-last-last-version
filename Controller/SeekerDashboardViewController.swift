//
//  SeekerDashboardViewController.swift
//  MobileProg
//
//  Created by aqeela Alghasrah on 6/9/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//
import Firebase
import UIKit

class SeekerDashboardViewController:UIViewController{

    @IBAction func btnStart(_ sender: Any) {
        let s = UIStoryboard(name: "Seeker", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "PreSessionQuiz")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
}
