//
//  Weather.swift
//  Json CoreLocation Weather
//
//  Created by Yermakov Anton on 14.10.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    
    var summary : String
    var icon : String
    var temperature : Double
    
    enum SerializationError : Error {
        case missing(String)
    }
    
    init (json: [String: Any]) throws {
        
        guard let summary = json["summary"] as? String else { throw SerializationError.missing("The summary is missing")}
        guard let icon = json["icon"] as? String else { throw SerializationError.missing("The icon is missing")}
        guard let temperature = json["temperatureMax"] as? Double else { throw SerializationError.missing("The temperature is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
    }
    
    
    
} // class






