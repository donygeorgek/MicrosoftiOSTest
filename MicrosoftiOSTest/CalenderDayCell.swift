//
//  CalenderDayCell.swift
//  MicrosoftiOSTest
//
//  Created by Dony George on 08/12/17.
//  Copyright © 2017 Dony George. All rights reserved.
//

import UIKit

protocol CalenderDayCellDelegate : class {
    func didTappedDate(catageriesData: [[String : Any]])
}


class CalenderDayCell: UICollectionViewCell {
    
    var thisDate: Date? {
        didSet {
            
            let order = NSCalendar.current.compare(thisDate!, to: Date(), toGranularity: .day)
            if order == .orderedSame {
                
                self.selectTodayCell()
                
            }else{
                
                self.selectNormalCell()
                
            }
        }
    }
    
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    weak var delegate: CalenderDayCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.delegate?.didTappedDate(catageriesData: [])
    }
    
    
    func selectTodayCell (){
        
        self.contentView.backgroundColor = UIColor.lightGray
        
    }
    
    func selectNormalCell (){
        
        self.contentView.backgroundColor = UIColor.init(hex: "E5EDF4")
        
    }
    
    func selectCell (){
        
        self.dayLbl.backgroundColor = UIColor.blue
        self.dayLbl.layer.cornerRadius = self.dayLbl.bounds.width/2
        self.dayLbl.clipsToBounds = true
        
    }
    
    func unSelectCell (){
        
        self.dayLbl.backgroundColor = UIColor.clear
        self.dayLbl.layer.cornerRadius = 0
        self.dayLbl.clipsToBounds = false
        
    }

}
