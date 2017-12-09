//
//  ViewController.swift
//  MicrosoftiOSTest
//
//  Created by Dony George on 08/12/17.
//  Copyright © 2017 Dony George. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var weekDayNames:[String] = Array()
    var currentDate : Date!
    var currentMonthDays : Int!
    var currentMonthFirstWeekDay : Int!
    var previousDate : Date!
    var previousMonthDays : Int!
    var nextDate : Date!
    var dateSelected: Date!
    


    //Week days collection view
    @IBOutlet weak var calenderDayCollectionView: UICollectionView!
    //Month days collection view
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    //Agenda table view
    @IBOutlet weak var agendaTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpNavigationButtons()
        registerCustomCells()
        initializeDatas()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Func to register custom cells
    func registerCustomCells(){
        
        calenderCollectionView.register(UINib(nibName: "CalenderDayCell", bundle: Bundle(for: CalenderDayCell.self)), forCellWithReuseIdentifier: "CalenderDayCell")
        agendaTableView.register(UINib(nibName: "AgendaListCell", bundle: Bundle(for: AgendaListCell.self)), forCellReuseIdentifier: "AgendaListCell")
        agendaTableView.tableFooterView = UIView()
    }
    
    //Function to setup navigation buttons
    func setUpNavigationButtons(){
        
        var barButtonItemBack:UIBarButtonItem!
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action:#selector(moveBackwordMonth), for: .touchUpInside)
        barButtonItemBack = UIBarButtonItem(customView: backButton)
        
        
        var barButtonItemForward:UIBarButtonItem!
        let forwardButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        forwardButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        forwardButton.contentHorizontalAlignment = .left
        forwardButton.addTarget(self, action:#selector(moveForwardMonth), for: .touchUpInside)
        barButtonItemForward = UIBarButtonItem(customView: forwardButton)
        
        self.navigationItem.leftBarButtonItems = [barButtonItemBack]
        self.navigationItem.rightBarButtonItems = [barButtonItemForward]
        
   
    }
    
    //Function to change month name
    func updateMonthTitle(date: Date){
        
        currentMonthDays = getNumberOfDays(inMonth: date)
        currentMonthFirstWeekDay = getFirstWeekDay(forDate: date)
        let result = calenderTitleFormatter().string(from: date).uppercased()
        self.title = "\(result)"
        
    }
    
    //Function to move month forward
    func moveForwardMonth(){
        
        let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        currentDate = newDate
        previousDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        nextDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        previousMonthDays = getNumberOfDays(inMonth: previousDate)
        
        updateMonthTitle(date: currentDate)
        calenderCollectionView.reloadData()
        
    }
    
    //Function to move month backward
    func moveBackwordMonth(){
        
        let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        currentDate = newDate
        previousDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        nextDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        previousMonthDays = getNumberOfDays(inMonth: previousDate)
        
        updateMonthTitle(date: currentDate)
        calenderCollectionView.reloadData()
        
    }
    
    //Function to initialize datas
    func initializeDatas(){
        
        currentDate = Date()
        previousDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        nextDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        weekDayNames = getWeekDays()
        previousMonthDays = getNumberOfDays(inMonth: previousDate)
        
        updateMonthTitle(date: currentDate)
        self.calenderDayCollectionView.reloadData()
        
        
    }
    
    //Function to get week days
    func getWeekDays() -> Array<String>{
        
        let formatter = DateFormatter.init()
        return formatter.shortWeekdaySymbols
        
    }
    
    //Function to get formatter for month year
    func calenderTitleFormatter() -> DateFormatter {
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    //Function to get formatter for month
    func monthFormatter() -> DateFormatter {
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MMM"
        return formatter
    }
    
    //Function to get formatter for date creation
    func returnDateFormatter() -> DateFormatter {
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    
    //Function to get no of days for month
    func getNumberOfDays(inMonth currentMonth:Date) -> Int {
        
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonth)
        return (range?.count)!
    }
    
    //Function to get first week day
    func getFirstWeekDay(forDate date:Date) -> Int {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        //Creating a date of 1st of the month
        let firstDayDate = returnDateFormatter().date(from:String(format: "1/%d/%d",components.month!, components.year!))
        let firstComponents = calendar.dateComponents([.weekday], from: firstDayDate!)
    
        //Getting the weekday for 1st of the month
        return firstComponents.weekday!
    }
    
    
    //Function to get Date from cell index
    func getDate(fromIndex index:Int) -> Date {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let date = returnDateFormatter().date(from:String(format: "%d/%d/%d",index, components.month!, components.year!))
        
        return date!
    }

    
    
    
    //CollectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        
        if collectionView == calenderDayCollectionView{
            
            return weekDayNames.count
            
        }else{
            
            //6 Rows * No of days in a week
            return 42
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        
        if collectionView == calenderDayCollectionView{
            
            let weekDayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekdayCell", for: indexPath) as UICollectionViewCell
            let dayName = "\(weekDayNames[indexPath.row])"
            
            //Create a label to display the weekday name
            let dayLbl = UILabel(frame: CGRect(x: 0, y: 0, width: weekDayCell.bounds.width, height: weekDayCell.bounds.height))
            dayLbl.textAlignment = .center
            dayLbl.text = dayName
            dayLbl.font = UIFont.systemFont(ofSize: 12)
            weekDayCell.contentView.addSubview(dayLbl)
            
            
            return weekDayCell
            
            
        }else{
            
            let calenderCell:CalenderDayCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderDayCell", for: indexPath) as? CalenderDayCell
            
            let row = indexPath.row
            
            //Clear cell after reuse
            calenderCell?.unSelectCell()
            
            //Logic for identifying previous month, present month and next month
            
            if row < currentMonthFirstWeekDay - 1{
                
                let dateNo = row + previousMonthDays - currentMonthFirstWeekDay + 2
                calenderCell?.dayLbl.textColor = UIColor.lightGray
                calenderCell?.dayLbl.text = "\(dateNo)"
                calenderCell?.monthLbl.text = ""
                
            }else if row >= currentMonthFirstWeekDay - 1 && row <= currentMonthFirstWeekDay + currentMonthDays - 2{
                
                let dateNo = row - currentMonthFirstWeekDay + 2
                calenderCell?.dayLbl.textColor = UIColor.black
                calenderCell?.dayLbl.text = "\(dateNo)"
                
                //Identify 1st of the month and add the month name in the cell
                if dateNo == 1{
                    
                    calenderCell?.monthLbl.text = "\(monthFormatter().string(from: currentDate).uppercased())"
                    
                }else{
                    
                    calenderCell?.monthLbl.text = ""
                    
                }
                
                //Create current cell date object
                let thisDate = getDate(fromIndex: dateNo)
                calenderCell?.thisDate = thisDate
                
                
                if dateSelected != nil{
                    
                    //Checking if the cell has the selected date
                    let order = NSCalendar.current.compare(thisDate, to: dateSelected, toGranularity: .day)
                    if order == .orderedSame {
                        
                        calenderCell?.selectCell()
                        
                    }else{
                        
                        calenderCell?.unSelectCell()
                        
                    }
                    
                }
                
                
                
                
                
            }else if row > currentMonthFirstWeekDay + currentMonthDays - 2{
                
                let dateNo = row - currentMonthDays - currentMonthFirstWeekDay + 2
                calenderCell?.dayLbl.textColor = UIColor.lightGray
                calenderCell?.dayLbl.text = "\(dateNo)"
                calenderCell?.monthLbl.text = ""
                
            }else{
                
                calenderCell?.dayLbl.text = ""
                calenderCell?.monthLbl.text = ""
                
            }
            
            return calenderCell!
            
        }
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        
        if collectionView == calenderCollectionView{
            
            
            let row = indexPath.row
            
            //Logic for identifying previous month, present month and next month
            
            if row < currentMonthFirstWeekDay - 1{
                
                //            let dateNo = row + previousMonthDays - currentMonthFirstWeekDay + 2
                
            }else if row >= currentMonthFirstWeekDay - 1 && row <= currentMonthFirstWeekDay + currentMonthDays - 2{
                
                let dateNo = row - currentMonthFirstWeekDay + 2
                dateSelected = getDate(fromIndex: dateNo)
                collectionView.reloadData()
                
            }else if row > currentMonthFirstWeekDay + currentMonthDays - 2{
                
                //            let dateNo = row - currentMonthDays - currentMonthFirstWeekDay + 2
                
            }else{
                
                
            }
            
            
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        
        if collectionView == calenderDayCollectionView{
            
            return CGSize(width: (collectionView.frame.width - 6) / 7, height: 20)
            
            
        }else{
            
            return CGSize(width: (collectionView.frame.width - 6) / 7, height: (collectionView.frame.height - 6) / 6)
            
        }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        if collectionView == calenderDayCollectionView{
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            
        }else{
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        }
        
        
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == calenderDayCollectionView{
            
            return 1
            
            
        }else{
            
            return 1
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        
        if collectionView == calenderDayCollectionView{
            
            return 1
            
            
        }else{
            
            return 1
            
        }
        
    }

    
    //Tableview Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var agendaCell:AgendaListCell? = tableView.dequeueReusableCell(withIdentifier: "AgendaListCell", for: indexPath) as? AgendaListCell
        
        if agendaCell == nil {
            
            agendaCell = AgendaListCell(style: .default, reuseIdentifier: "AgendaListCell")
        }
        
        agendaCell?.selectionStyle = .none
        
        return agendaCell!
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }



}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    
}


