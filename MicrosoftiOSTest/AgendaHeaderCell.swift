//
//  AgendaHeaderCell.swift
//  MicrosoftiOSTest
//
//  Created by Dony George on 11/12/17.
//  Copyright © 2017 Dony George. All rights reserved.
//

import UIKit

class AgendaHeaderCell: UITableViewCell {

    @IBOutlet weak var weatherTitle: UILabel!
    @IBOutlet weak var agendaTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
