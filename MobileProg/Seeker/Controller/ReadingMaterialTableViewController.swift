//
//  ReadingMaterialTableViewController.swift
//  MobileProg
//
//  Created by MobileProg-Class1 on 6/18/19.
//  Copyright © 2019 polytechnic.bh. All rights reserved.
//

import UIKit
import Firebase

@available(iOS 11.0, *)
class ReadingMaterialTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var Searchbar: UISearchBar!
    public var materials = [ReadingMaterial]()
    public var allMaterials = [ReadingMaterial]()
    public var selectedMaterial: ReadingMaterial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMaterials()
        setUpSearchBar()
        print(self.materials.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    
    // MARK: - Table view data source
    private func setUpSearchBar() {
        Searchbar.autocapitalizationType = .none
        Searchbar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { self.materials = self.allMaterials
            self.tableView.reloadData(); return }
        self.materials = self.allMaterials.filter({material -> Bool in
            return          (material.title.lowercased().contains(searchText.lowercased()) || material.description.lowercased().contains(searchText.lowercased()))
        })
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.materials.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell  {
        
        let cellIdentifier = "ReadingMaterialViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReadingMaterialTableViewCell else {
            fatalError("The dequeued cell is not an instance of ReadingMaterialTableViewCell.")
            
        }
        
        let material = self.materials[indexPath.row]
            
            print("Now")
        
        cell.lblmaterialtitle.text = material.title
        cell.lblDescription.text = material.description
        
            
            return cell
    }

    
    func loadMaterials() {
        self.materials.removeAll()
        let ref = Database.database().reference().child("Material")
        let query = ref.queryOrdered(byChild: "id")
        query.observe(.value, with: {(snapshot) in for childSnapshot in snapshot.children {
            print(childSnapshot)
            //            let childSnap = childSnapshot as! DataSnapshot
            //            let dict = childSnap.value as! [String: Any]
            //            let title = dict["title"] as! String
            //            print(title)
            //            print(snapshot.children)
            let childSnap = childSnapshot as! DataSnapshot
            let dict = childSnap.value as! [String: Any]
            let title = dict["title"] as! String
            let description = dict["description"] as! String
            let link = dict["link"] as! String
            
            print(title)
            
            guard let material = ReadingMaterial(title: title, description: description, link: link) else {
                fatalError("Unable to instantiate this material")
            }
            material.id = childSnap.key
            self.materials += [material]
            self.allMaterials = self.materials
            }
            self.tableView.reloadData()
        })
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = UIStoryboard(name: "Seeker", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "viewReadingMeterial") as! ReadinMeterialViewTableViewController
        
        
       vc.id = allMaterials[indexPath.row].id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
