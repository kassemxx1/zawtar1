//
//  GuideViewController.swift
//  zawtar
//
//  Created by kassem on 5/20/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import SVProgressHUD

class GuideViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var guide : [Company] = [Company]()
    @IBOutlet weak var GuideTable: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        GuideTable.delegate = self
        GuideTable.dataSource = self
        retrieve()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guide.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellidentifier = "newCustomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier) as! newCustomCell
        cell.nameLabel.text = guide[indexPath.row].nameOfCompany
        cell.numLabel.text = String(int_fast64_t(guide[indexPath.row].numbOfCompany))
        return cell
        
    }
    
    func retrieve() {
        guide.removeAll()
        SVProgressHUD.show()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        db.collection("TypeOfCompany").getDocuments()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents  {
                        let guide = Company(context: self.context)
                        
                        let nameOfCompany = document.data()["nameOfCompany"] as? String
                        let numbOfCompany = document.data()["numbOfCompany"] as? Double
                        guide.nameOfCompany = nameOfCompany
                        guide.numbOfCompany = numbOfCompany!
                        print(guide)
                        self.guide.insert(guide, at: 0)
                        
                        //   self.saveItems()
                        SVProgressHUD.dismiss()
                        self.GuideTable.reloadData()
                    }
                }
                
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! newCustomCell
        phoneCall(to: cell.numLabel.text!,name : cell.nameLabel.text!)
    }
    func phoneCall(to phoneNumber:String ,name : String) {
        
        if let callURL:URL = URL(string: "tel:\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            
            if (application.canOpenURL(callURL)) {
                let alert = UIAlertController(title: "Hello", message: "Do you want call \(name)?", preferredStyle: .alert)
                let callAction = UIAlertAction(title: "Call", style: .default, handler: { (action) in
                    application.open(callURL, options: [:], completionHandler: nil)
                })
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                    print("Canceled Call")
                })
                alert.addAction(callAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Company> = Company.fetchRequest()
        let predicate = NSPredicate(format:"nameOfCompany CONTAINS[cd] %@",searchBar.text!)
        request.predicate = predicate
        let sortDescriptors = NSSortDescriptor(key: "nameOfCompany", ascending: true)
        request.sortDescriptors = [sortDescriptors]
        do {
            guide = try context.fetch(request)
          self.GuideTable.reloadData()
        }catch {
            print(error)
        }
       
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request : NSFetchRequest<Company> = Company.fetchRequest()
        if searchBar.text?.count == 0 {
            do {
                guide = try context.fetch(request)
            }catch {
                print(error)
            }
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
       self.GuideTable.reloadData()
    }
}


