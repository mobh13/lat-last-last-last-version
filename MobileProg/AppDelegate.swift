//
//  AppDelegate.swift
//  MobileProg
//
//  Created by MobileProg on 4/29/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var currentUser:User?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navigationController = application.windows[0].rootViewController as! UINavigationController
        FirebaseApp.configure()
        
        do{
            try Auth.auth().signOut()
            let s = UIStoryboard(name: "Main", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "MainScreen")
            
            
            navigationController.pushViewController(vc, animated: true)
            
        }catch{
            print("error signing out !!")
        }
        
//                let s = UIStoryboard(name: "Admin", bundle: nil)
//                let vc = s.instantiateViewController(withIdentifier: "adminDashboard")
//                navigationController.pushViewController(vc, animated: true)
        if Auth.auth().currentUser?.uid != nil {
            Database.database().reference().child("User").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary

                if let  type = value?.value(forKey: "Role") as? String{
                    if type == "Admin"{
                        let s = UIStoryboard(name: "Admin", bundle: nil)
                        let vc = s.instantiateViewController(withIdentifier: "adminDashboard")
                        navigationController.pushViewController(vc, animated: true)
                    }else if type == "Doctor"{

                        let s = UIStoryboard(name: "Doctor", bundle: nil)
                        let vc = s.instantiateViewController(withIdentifier: "doctorTabBar")
                        navigationController.pushViewController(vc, animated: true)
                    } else if type == "Volunteer"{

                        let s = UIStoryboard(name: "Volunteer", bundle: nil)
                        let vc = s.instantiateViewController(withIdentifier: "vounteerHome")
                        navigationController.pushViewController(vc, animated: true)

                    }else if type == "Seeker"{
                        let s = UIStoryboard(name: "Seeker", bundle: nil)
                        let vc = s.instantiateViewController(withIdentifier: "SeekerTab")
                       navigationController.pushViewController(vc, animated: true)
                    }
                    else{
                        print("Error")
                    }
                }

            }  )




        }
        else {
            let s = UIStoryboard(name: "Main", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "MainScreen")
            navigationController.pushViewController(vc, animated: true)
            //User Not logged in
        }
        
        
        
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MobileProg")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

