//
//  ViewController.swift
//  MicrosoftiOSTest
//
//  Created by Dony George on 08/12/17.
//  Copyright © 2017 Dony George. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    //Array of weekdays
    var weekDayNames:[String] = Array()
    //Current month date
    var currentDate : Date!
    //No of days in the month
    var currentMonthDays : Int!
    //First weekday of the current month
    var currentMonthFirstWeekDay : Int!
    //Previous month date
    var previousDate : Date!
    //No of days in previous month
    var previousMonthDays : Int!
    //Next month date
    var nextDate : Date!
    //Selected date
    var dateSelected: Date!
    //Variable to hold randon dates containing events
    var randomEventsDates: [Date] = []
    //Data for agenda tableview
    var agendaData: [[String: Any]] = []
    //Dummy events Data
    var dummyEventsData: [[String: Any]] = []
    //Agenda header title
    var agendaheaderTitle: String = ""
    //Agenda Weather title
    var agendaWeatherTitle: String = ""


    //Week days collection view
    @IBOutlet weak var calenderDayCollectionView: UICollectionView!
    //Month days collection view
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    //Agenda table view
    @IBOutlet weak var agendaTableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupLocationAccess()
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
        agendaTableView.register(UINib(nibName: "AgendaHeaderCell", bundle: Bundle(for: AgendaHeaderCell.self)), forCellReuseIdentifier: "AgendaHeaderCell")
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
    
    //Function to load dummy events data from the json file
    func loadEventsDummyData() {
        do {
            if let file = Bundle.main.url(forResource: "eventsDataset", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    dummyEventsData  = object["events"] as! [[String : Any]]
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("Invalid file")
                }
            } else {
                print("File not found")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    //Function to initialize datas
    func initializeDatas(){
        
        
        loadEventsDummyData()
        currentDate = Date()
        previousDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        nextDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        weekDayNames = getWeekDays()
        previousMonthDays = getNumberOfDays(inMonth: previousDate)
        updateMonthTitle(date: currentDate)
        randomEventsDates = getRandonDates()
        
        self.calenderDayCollectionView.reloadData()
        
        
    }
    
    //Function to get random dates with events
    func getRandonDates() -> [Date]{
        
        var dateArray: [Date] = []
        
        for _ in 0..<15{
            
            //Selecting random dates from current month
            let randomNo = Int(arc4random_uniform(UInt32(currentMonthDays)) + 1)
            let randomDate = getDate(fromIndex: randomNo)
            dateArray.append(randomDate)
        }
        
        return dateArray
    }
    
    
    //Function to load dummy events for selected date
    func loadRandomEventsForDate(){
        agendaData.removeAll()
        //Generating random number of events for a day
        let randomCount = Int(arc4random_uniform(UInt32(dummyEventsData.count)) + 1)
        
        for var i in 0..<randomCount{
            
            agendaData.append(dummyEventsData[i])
        }
        
        self.agendaTableView.reloadData()
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
    
    //Function to get formatter for agenda title
    func agendaTitleFormatter() -> DateFormatter {
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "EEEE MMMM dd yyyy"
        return formatter
    }
    
    //Function to get agenda title  for selected date
    func getAgendaTitle(fromDate:Date) -> String {
        
        let result = agendaTitleFormatter().string(from: fromDate).uppercased()
        
        let order = NSCalendar.current.compare(fromDate, to: currentDate, toGranularity: .day)
        if order == .orderedSame {
            
            return "TODAY, \(result)"
            
        }else{
            
            return result
            
        }
        
        
        
        
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

    
    
    // Show alert if app has been deined access to location
    func showLocationDisabledAlert() {
        let alertController = UIAlertController(title: "Location Access Disabled",
                                                message: "Please enable it from settings",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //Func to seup location access
    func setupLocationAccess(){
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    
    //Func to get the weather
    func loadWeatherForLocation(lat: String, long: String){
        
        let apiClient = WeatherAPIClient()
        apiClient.getWeatherForLocation(lat: lat, long: long) { (responseDict, success) in
            print("WeatherApi Response: \(responseDict)")
            if success{
                if responseDict["currently"] != nil{
                    
                    let weatherDict =  responseDict["currently"] as! [String: Any]
                    
                    self.agendaWeatherTitle = "Forecast: \(String(describing: weatherDict["summary"]!)) - Temp: \(String(describing: weatherDict["temperature"]!)) F - Humidity: \(String(describing: weatherDict["humidity"]!)) - Windspeed: \(String(describing: weatherDict["windSpeed"]!))"
                    
                }
                DispatchQueue.main.async {
                }
                
            }else{
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Something went wrong", message: "", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(ok)
                    //Not showning the alert for now
                    //self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    

    // MARK: - Location manager delegate methods
    
    // Get location info and call api
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            loadWeatherForLocation(lat: "\(location.coordinate.latitude)", long: "\(location.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
            print(location.coordinate)
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledAlert()
        }
    }
    
    
    // MARK: - Collection view data source and delegate methods
    
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
                
                calenderCell?.isEventPresent = false
                let dateNo = row + previousMonthDays - currentMonthFirstWeekDay + 2
                calenderCell?.dayLbl.textColor = UIColor.lightGray
                calenderCell?.dayLbl.text = "\(dateNo)"
                calenderCell?.monthLbl.text = ""
                
                
            }else if row >= currentMonthFirstWeekDay - 1 && row <= currentMonthFirstWeekDay + currentMonthDays - 2{
                
                let dateNo = row - currentMonthFirstWeekDay + 2
//                calenderCell?.isEventPresent = true
                calenderCell?.dayLbl.textColor = UIColor.black
                calenderCell?.dayLbl.text = "\(dateNo)"
                
                //Identify 1st of the month and add the month name in the cell
                if dateNo == 1{
                    
                    calenderCell?.monthLbl.text = "\(monthFormatter().string(from: currentDate).uppercased())"
                    
                }else{
                    
                    calenderCell?.monthLbl.text = ""
                    
                }
                
                //Create current cell date object
                let cellDisplayDate = getDate(fromIndex: dateNo)
                if randomEventsDates.contains(cellDisplayDate){
                    
                    calenderCell?.isEventPresent = true
                    
                }else{
                    
                    calenderCell?.isEventPresent = false
                    
                }
                calenderCell?.cellDisplayDate = cellDisplayDate
                
                
                //Checking if selected date is set
                if dateSelected != nil{
                    
                    //Create selected date object
                    let cellSelectedDate = dateSelected
                    calenderCell?.cellSelectedDate = cellSelectedDate
                    
                }
                
            
                
            }else if row > currentMonthFirstWeekDay + currentMonthDays - 2{
                
                calenderCell?.isEventPresent = false
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
                
                agendaheaderTitle = getAgendaTitle(fromDate: dateSelected)
                collectionView.reloadData()
                
                if randomEventsDates.contains(dateSelected){
                    
                    loadRandomEventsForDate()
                }else{
                    
                    agendaData.removeAll()
                    agendaTableView.reloadData()
                    
                }
                
                
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

    
    // MARK: - Table view data source and delegate methods
    
    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "AgendaHeaderCell") as! AgendaHeaderCell
        headerCell.backgroundColor = UIColor.init(hex: "ECF3F9")
        headerCell.agendaTitle.text = "\(agendaheaderTitle)"
        headerCell.weatherTitle.text = "\(agendaWeatherTitle)"
        
        return headerCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if agendaData.count > 0 {
            
            return 34
            
        }else{
            
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return agendaData.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var agendaCell:AgendaListCell? = tableView.dequeueReusableCell(withIdentifier: "AgendaListCell", for: indexPath) as? AgendaListCell
        
        if agendaCell == nil {
            
            agendaCell = AgendaListCell(style: .default, reuseIdentifier: "AgendaListCell")
        }
        
        
        let agendaItem = agendaData[indexPath.row]
        agendaCell?.eventNameLbl.text = "\(String(describing: agendaItem["eventName"]!))"
        agendaCell?.eventLocationLbl.text = "\(String(describing: agendaItem["eventLocName"]!))"
        agendaCell?.timeLbl.text = "\(String(describing: agendaItem["eventTime"]!))"
        agendaCell?.selectionStyle = .none
        agendaCell?.roundView.layer.cornerRadius = 5
        
        return agendaCell!
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }



}

// MARK: - Color extension

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


