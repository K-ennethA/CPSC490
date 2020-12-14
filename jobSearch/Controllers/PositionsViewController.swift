//
//  PositionsViewController.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/5/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit
import Firebase

class PositionsViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var positionsViewController: UITableView!
    
    var companyName: String = ""
    var positions: [Position] = []
    var position: Position = Position(positionName: "", dateApplied: "", status: "", details: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        positionsViewController.dataSource = self
        positionsViewController.delegate = self
        positionsViewController.register(UINib(nibName: "PositionsTableViewCell", bundle: nil), forCellReuseIdentifier: "PositionsCell")
        loadPositions()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "positionDetailSegue" {
            let positionsDetailVC = segue.destination as? PositionsDetailViewController
            positionsDetailVC?.position = position
        }
    }
    
    func loadPositions() {
        db.collection("Users").document(User.sharedInstance.email).collection("Applications").document(companyName).collection("Positions")
            .addSnapshotListener { (querySnapshot, error) in
            
            self.positions = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let positionName = data["positionName"] as? String, let dateApplied = data["dateApplied"] as? String, let status = data["status"] as? String, let details = data["details"] as? String  {
                            let newCompany = Position(positionName: positionName, dateApplied: dateApplied, status: status, details: details)
                            self.positions.append(newCompany)
                            
                            DispatchQueue.main.async {
                                self.positionsViewController.reloadData()
                                let indexPath = IndexPath(row: self.positions.count - 1, section: 0)
                                self.positionsViewController.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
                
    }



}

extension PositionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = positionsViewController.dequeueReusableCell(withIdentifier: "PositionsCell", for: indexPath) as! PositionsTableViewCell
        cell.positionName.text = positions[indexPath.row].positionName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        position = positions[indexPath.row]
        self.performSegue(withIdentifier: "positionDetailSegue", sender: self)
    }
}
