//
//  positionDetailViewController.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/6/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit

class PositionsDetailViewController: UIViewController {
    
    @IBOutlet weak var positionName: UILabel!
    @IBOutlet weak var dateApplied: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
    var position: Position = Position(positionName: "", dateApplied: "", status: "", details: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        positionName.text = position.positionName
        dateApplied.text = position.dateApplied
        details.text = position.details
        status.text = position.status
    }
}
