//
//  NetworkProcessor.swift
//  Json CoreLocation Weather
//
//  Created by Anton Yermakov on 18.04.2018.
//  Copyright © 2018 Yermakov Anton. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkProcessor{
    
    private init() {}
    static let sharedInstance = NetworkProcessor()
    
     let basePath = "https://api.darksky.net/forecast/ff488868004ccf5b4f044a8620226b22/"
    
     func dowbloadJson(fromLoaction location: CLLocationCoordinate2D, completion: @escaping ([Weather]) -> () ) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data else { return }
            var forecastArray : [Weather] = []
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if let daily = json["daily"] as? [String : Any] {
                        if let date = daily["data"] as? [[String : Any]] {
                            for datePoint in date {
                                if let weatherObject = try? Weather(json: datePoint) {
                                    forecastArray.append(weatherObject)
                                }
                            }
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            completion(forecastArray)
        }
        
        task.resume()
    }
    
    
} // class
