//
//  AgendaListCell.swift
//  MicrosoftiOSTest
//
//  Created by Dony George on 08/12/17.
//  Copyright © 2017 Dony George. All rights reserved.
//

import UIKit

class AgendaListCell: UITableViewCell {

    @IBOutlet weak var eventLocationLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
