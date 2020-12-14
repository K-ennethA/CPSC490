//
//  UpcomingEventsViewController.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/6/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit
import Firebase

class UpcomingEventsViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var upcomingEventsTableView: UITableView!
    
    var events: [Event] = []
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        upcomingEventsTableView.dataSource = self
        upcomingEventsTableView.delegate = self
        upcomingEventsTableView.register(UINib(nibName: "UpcomingEventsTableViewCell", bundle: nil), forCellReuseIdentifier: "upcomingEventsCell")
        loadEvents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
         if segue.identifier == "eventDetailSegue" {
            let detailsVC = segue.destination as? UpcomingEventsDetailViewController
            
            detailsVC?.event.name = event.name
            detailsVC?.event.details = event.details
            detailsVC?.event.startDate = event.startDate
            
            print("gow")
         }
     }
    func loadEvents() {
        db.collection("Users").document(User.sharedInstance.email).collection("calEvent")
            .order(by: "start")
            .addSnapshotListener { (querySnapshot, error) in
            
            self.events = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let eventName = data["name"] as? String, let eventDetail = data["details"] as? String, let date = data["start"] as? String {
                            let newEvent = Event(name: eventName, startDate: date, color: "red", details: eventDetail)
                            self.events.append(newEvent)
                            
                            DispatchQueue.main.async {
                                self.upcomingEventsTableView.reloadData()
                                let indexPath = IndexPath(row: self.events.count - 1, section: 0)
                                self.upcomingEventsTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
}


extension UpcomingEventsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let body = events[indexPath.row]
        let cell = upcomingEventsTableView.dequeueReusableCell(withIdentifier: "upcomingEventsCell", for: indexPath) as! UpcomingEventsTableViewCell
        cell.EventNameLabel.text = body.name
        cell.EventDateLabel.text = body.startDate
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        event = events[indexPath.row]
        self.performSegue(withIdentifier: "eventDetailSegue", sender: self)
        print("hei")
    }
    
    
}
