//
//  CompanyTableViewCell.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/5/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var companyNameCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
