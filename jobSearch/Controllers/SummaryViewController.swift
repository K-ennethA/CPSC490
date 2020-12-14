//
//  SummaryViewController.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/24/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit
import Firebase

class SummaryViewController: UIViewController {
    let db = Firestore.firestore()
    var companies: [Company] = []
    var positions: Int = 0

    @IBOutlet weak var companiesTableView: UITableView!
    @IBOutlet weak var numPositions: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        getApplications()

        print("yo")

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        companiesTableView.dataSource = self
        companiesTableView.delegate = self
        companiesTableView.register(UINib(nibName: "CompaniesAppliedToTableViewCell", bundle: nil), forCellReuseIdentifier: "CompaniesAppliedCell")
        print("hey")
        getCompanies()
//        getCompanies(completion: {
//            getApplications()
//        })

    }
    func getCompanies() {
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
                            print("companies after get are \(self.companies)")

                            self.getApplications()
                            DispatchQueue.main.async {
                                self.companiesTableView.reloadData()
                                let indexPath = IndexPath(row: self.companies.count - 1, section: 0)
                                self.companiesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
        print("companies after get are \(companies)")
    }
    
    func getApplications() {
        print("companies are \(companies)")
        for company in companies {
            db.collection("Users").document(User.sharedInstance.email).collection("Applications").document(company.companyName).collection("Positions")
                .addSnapshotListener { (querySnapshot, error) in
                
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for _ in snapshotDocuments {
                            self.positions += 1
                        }
                        self.numPositions.text = String(self.positions)
                    }
                }
            }
        }
        print("count is \(positions)")
    }
    

    @IBAction func filterBtn(_ sender: Any) {

        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action) in
         // Respond to user selection of the action
        }
             
        let thisWeek = UIAlertAction(title: "This Week",
                                    style: .default) { (action) in
         // Respond to user selection of the action
        }
        
        let thisMonth = UIAlertAction(title: "This Month",
                                    style: .default) { (action) in
         // Respond to user selection of the action
        }
        let lastMonth = UIAlertAction(title: "Last Month",
                                    style: .default) { (action) in
         // Respond to user selection of the action
        }
        let lastSixMonths = UIAlertAction(title: "Last 6 Months",
                                    style: .default) { (action) in
         // Respond to user selection of the action
        }
             
        let alert = UIAlertController(title: "Filter summary results",
                    message: "",
                    preferredStyle: .actionSheet)
        alert.addAction(thisWeek)
        alert.addAction(cancelAction)
        alert.addAction(thisMonth)
        alert.addAction(lastMonth)
        alert.addAction(lastSixMonths)
                          
        self.present(alert, animated: true) {
           // The alert was presented
        }

    }
}

extension SummaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = companiesTableView.dequeueReusableCell(withIdentifier: "CompaniesAppliedCell", for: indexPath) as! CompaniesAppliedToTableViewCell
        let body = companies[indexPath.row]
        cell.companyCell.text = body.companyName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        company = companies[indexPath.row].companyName
        self.performSegue(withIdentifier: "positionsSegue", sender: self)
    }
    
    
}
