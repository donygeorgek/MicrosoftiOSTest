//
//  CalenderDayCell.swift
//  MicrosoftiOSTest
//
//  Created by Dony George on 08/12/17.
//  Copyright © 2017 Dony George. All rights reserved.
//

import UIKit

//Unused
protocol CalenderDayCellDelegate : class {
    func didTappedDate(selectedDate: Date)
}


class CalenderDayCell: UICollectionViewCell {
    
    var isEventPresent: Bool = false
    
    //Date to be displayed on each cell
    var cellDisplayDate: Date? {
        didSet {
            
            setupCellPattern()
            
        }
    }
    
    //Selected date variable
    var cellSelectedDate: Date? {
        
        didSet {
            
            setupCellPattern()
            
        }
    }

    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    weak var delegate: CalenderDayCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    
    func setupCellPattern(){
        
        //Check if selected date is set
        if cellSelectedDate != nil{
            
            //Check if selected date and cell date are same
            let order = NSCalendar.current.compare(cellDisplayDate!, to: cellSelectedDate!, toGranularity: .day)
            if order == .orderedSame {
                
                self.selectCell()
                //Hiding the month label in the cell for 1st day
                self.monthLbl.isHidden = true
                self.roundView.isHidden = true
                
            }else{
                
                self.checkForTodayCell()
                //Showing the month label in the cell for 1st day
                self.monthLbl.isHidden = false
                if isEventPresent{
                    
                    self.roundView.isHidden = false
                    
                }else{
                    
                    self.roundView.isHidden = true
                    
                }
            }
            
        }else{
            
            self.checkForTodayCell()
            //Showing the month label in the cell for 1st day
            self.monthLbl.isHidden = false
            if isEventPresent{
                
                self.roundView.isHidden = false
                
            }else{
                
                self.roundView.isHidden = true
                
            }
            
        }
        
        
    }
    
    //Function to check for today cell
    func checkForTodayCell(){
        
        let order = NSCalendar.current.compare(cellDisplayDate!, to: Date(), toGranularity: .day)
        if order == .orderedSame {
            
            self.selectTodayCell()
            
            
        }else{
            
            self.selectNormalCell()
            
        }

        
    }
    
    
    //Function to set the style for today cell
    func selectTodayCell (){
        
        self.dayLbl.backgroundColor = UIColor.lightGray
        self.dayLbl.textColor = UIColor.black
        self.dayLbl.layer.cornerRadius = self.dayLbl.bounds.width/2
        self.dayLbl.clipsToBounds = true
        self.contentView.backgroundColor = UIColor.init(hex: "E5EDF4")
        self.roundView.layer.cornerRadius = self.roundView.bounds.width/2
        self.roundView.isHidden = true
        
    }
    
    //Function to set the style for normal cell
    func selectNormalCell (){
        
        unSelectCell()
        
    }
    
    //Function to set the style for selected date cell
    func selectCell (){
        
        self.dayLbl.backgroundColor = UIColor.init(hex: "3171C1")
        self.dayLbl.textColor = UIColor.white
        self.dayLbl.layer.cornerRadius = self.dayLbl.bounds.width/2
        self.dayLbl.clipsToBounds = true
        self.contentView.backgroundColor = UIColor.init(hex: "E5EDF4")
        self.roundView.layer.cornerRadius = self.roundView.bounds.width/2
        self.roundView.isHidden = true
        
    }
    
    //Function to set the style for unselected date cell
    func unSelectCell (){
        
        self.dayLbl.backgroundColor = UIColor.clear
        self.dayLbl.textColor = UIColor.black
        self.dayLbl.layer.cornerRadius = 0
        self.dayLbl.clipsToBounds = false
        self.contentView.backgroundColor = UIColor.init(hex: "E5EDF4")
        self.roundView.layer.cornerRadius = self.roundView.bounds.width/2
        self.roundView.isHidden = true
        
    }

}
