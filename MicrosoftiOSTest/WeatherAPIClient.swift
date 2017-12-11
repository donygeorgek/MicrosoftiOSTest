//
//  WeatherAPIClient.swift
//  MicrosoftiOSTest
//
//  Created by Dony George on 10/12/17.
//  Copyright © 2017 Dony George. All rights reserved.
//

import UIKit

class WeatherAPIClient: NSObject {
    
    
    //Get weather for location
    func getWeatherForLocation(lat:String, long: String,  completionHandler: @escaping (_ responseDict: Dictionary<String, AnyObject>, _ success: Bool) -> Void){
        
        let functionStr = "\(lat),\(long)"
        let failDict:[String: AnyObject] = [:]
        self.makeGetConnection(function: functionStr) { (responseDict, success) in
            
            if success{
                
                print("getWeatherForLocation Response Dict = \(responseDict)")
                
                completionHandler(responseDict , true)
                
            }else{
                
                completionHandler(failDict, false)
                
            }
            
        }
        
    }

    
    
    //API GET Connection
    func makeGetConnection(function: String, completionHandler: @escaping (_ responseDict: Dictionary<String, AnyObject>, _ success: Bool) -> Void){
        
        
        let failDict:[String: AnyObject] = [:]
        let reqURL = NSURL(string: "https://api.darksky.net/forecast/272d0997122bf7052a342ecb01feb1c8/\(function)")
        let request = NSMutableURLRequest(url: reqURL! as URL)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("\(function) API error=\(String(describing: error))")
                completionHandler(failDict, false)
                return
                
            }
            
            
            if let apiResponse = response as! HTTPURLResponse!{
                
                print("\(function) status code:\(apiResponse.statusCode)")
                //Checking status code
                    if apiResponse.statusCode == 200{
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            
                            if let responseDict = json {
                                
                                print("\(function) API response = \(responseDict)")
                                completionHandler(responseDict as! Dictionary, true)
                                return
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                        
                        
                        
                    }else{
                        
                        
                        completionHandler(failDict, false)
                        return
                        
                        
                    }
            }
        }
        
        task.resume()
        
    }


}
