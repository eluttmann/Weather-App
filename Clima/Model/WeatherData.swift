//
//  WeatherData.swift
//  Clima
//
//  Created by Eric Wildey Luttmann on 5/28/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//curate the structure for weather data to come in
struct WeatherData: Codable {
    let name: String
    //JSON top level property name = main; data type = object. Need to create separate struct to represnt hierarchy
    //main assumes Main structure data type
    let main: Main
    //group weather as an array
    let weather: [Weather]
}

//need to name property names & types according to API return JSON
struct Main: Codable {
    let temp: Double //decimal when look at JSON in URL
}

struct Weather: Codable {
    let description: String
    let id: Int
}





