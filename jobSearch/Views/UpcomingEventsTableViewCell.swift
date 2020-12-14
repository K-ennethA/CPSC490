//
//  UpcomingEventsTableViewCell.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/6/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit

class UpcomingEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var EventDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
