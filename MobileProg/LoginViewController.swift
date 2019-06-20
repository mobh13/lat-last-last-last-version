//
//  LoginViewController.swift
//  MobileProg
//
//  Created by Mohamed Madan on 6/18/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if txtEmail.text!.count == 0  || txtPassword.text!.count == 0   {
            let alert = UIAlertController(title: "Error", message: "Fields cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            
            Auth.auth().signIn(withEmail:  self.txtEmail.text!, password: self.txtPassword.text!) { [weak self] user, error in
                if error == nil {
                    guard let strongSelf = self else { return }
                    if let uid = user?.user.uid {
                        Database.database().reference().child("User").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                            let value = snapshot.value as? NSDictionary
                            let date = Date()
                            let format = DateFormatter()
                            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let formattedDate = format.string(from: date)
                          
                          let dbOb = ["Date": formattedDate ,
                                                         "Status": "Success",
                                                         "Platform" :  "Ios" ,
                                                         "UserId": uid
                                                      
                                ] as [String : Any]
                              Database.database().reference().childByAutoId().setValue(dbOb)
                            
                            if let  type = value?.value(forKey: "Role") as? String{
                                if type == "Admin"{
                                    let s = UIStoryboard(name: "Admin", bundle: nil)
                                    let vc = s.instantiateViewController(withIdentifier: "adminDashboard")
                                    self!.navigationController?.pushViewController(vc, animated: true)
                                }else if type == "Doctor"{
                                    
                                    let s = UIStoryboard(name: "Doctor", bundle: nil)
                                    let vc = s.instantiateViewController(withIdentifier: "doctorTabBar")
                                    self!.navigationController?.pushViewController(vc, animated: true)
                                } else if type == "Volunteer"{
                                    
                                    let s = UIStoryboard(name: "Volunteer", bundle: nil)
                                    let vc = s.instantiateViewController(withIdentifier: "vounteerHome")
                                    self!.navigationController?.pushViewController(vc, animated: true)
                                    
                                }else if type == "Seeker"{
                                    
                                    let s = UIStoryboard(name: "Seeker", bundle: nil)
                                    let vc = s.instantiateViewController(withIdentifier: "SeekerTab")
                                    self!.navigationController?.pushViewController(vc, animated: true)
                                }
                                else{
                                    print("Error")
                                }
                            }
                            
                        }  )
                        
                        
                    }
                    
                }else{
                     let date = Date()
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let formattedDate = format.string(from: date)
                    
                    let dbOb = ["Date": formattedDate ,
                                "Status": "Faild",
                                "Platform" :  "Ios" ,
                                "UserId": ""
                        
                        ] as [String : Any]
                    Database.database().reference().childByAutoId().setValue(dbOb)
                    let alert = UIAlertController(title: "Error", message: "Please Check your email and password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self!.present(alert, animated: true)
                    
                }
           
                
            }
        }
        
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        let s = UIStoryboard(name: "Main", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "choose") as! ViewController
        
        
        self.navigationController?.pushViewController(vc, animated: true)
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
