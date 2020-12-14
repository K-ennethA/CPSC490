//
//  ViewController.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/4/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit
import Firebase

class ComapanyApplicationsViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var companyApplicationsTableView: UITableView!
    
    var companies: [Company] = []
    var company: String = ""
    
    var user: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        companyApplicationsTableView.dataSource = self
        companyApplicationsTableView.delegate = self
        companyApplicationsTableView.register(UINib(nibName: "CompanyTableViewCell", bundle: nil), forCellReuseIdentifier: "CompanyCell")

        loadApplications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "positionsSegue" {
            let positionsVC = segue.destination as? PositionsViewController
            
            positionsVC?.companyName = company

        }
    }
    
    func loadApplications() {
        db.collection("Users").document(User.sharedInstance.email).collection("Applications")
            .addSnapshotListener { (querySnapshot, error) in
            
            self.companies = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let companyName = data["companyName"] as? String {
                            let newCompany = Company(companyName: companyName)
                            self.companies.append(newCompany)
                            
                            DispatchQueue.main.async {
                                self.companyApplicationsTableView.reloadData()
                                let indexPath = IndexPath(row: self.companies.count - 1, section: 0)
                                self.companyApplicationsTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }

    
    @IBAction func logOut(_ sender: Any) {
        print("hey")
    }
    
    
}
extension ComapanyApplicationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = companyApplicationsTableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyTableViewCell
        let body = companies[indexPath.row]
        cell.companyNameCell.text = body.companyName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        company = companies[indexPath.row].companyName
        self.performSegue(withIdentifier: "positionsSegue", sender: self)
    }
    
    
}
