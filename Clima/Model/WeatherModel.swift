//
//  WeatherModel.swift
//  Clima
//
//  Created by Eric Wildey Luttmann on 6/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    //purpose = retrieve temperature with 1 decimal
    //the property, temperatureString will be returned in itself as String
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    //return value of conditionName
    //switch based on conditionID (check for case #, then return String equal to conditionName)
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    
}


