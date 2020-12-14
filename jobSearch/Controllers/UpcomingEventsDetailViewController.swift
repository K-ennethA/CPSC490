//
//  UpcomingEventDetailViewController.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/6/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit

class UpcomingEventsDetailViewController: UIViewController {

    
    var event: Event = Event(name: "", startDate: "", color: "", details: "")
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDetailsLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        eventNameLabel.text = event.name
        eventDetailsLabel.text = event.details
        eventDateLabel.text = event.startDate
    }
}
