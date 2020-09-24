//
//  WeatherManager.swift
//  Clima
//
//  Created by Eric Wildey Luttmann on 5/15/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//requirement that to meet WeatherManagerDelegate protocol - need to be able to run didUpdateWeather
protocol WeatherManagerDelegate {
    func didUpdateWeather (_ weatherManager: WeatherManager, weather: WeatherModel)
    //Add delegate method to help pass errors out of weatherManager
    //input = error; type = error
    func didFailWithError(error: Error)
}

struct WeatherManager {
    //this creates the base URL call that we will add to programatically
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=imperial&appid=87558676d86277a2178a8ea2799def0c"
    
    //
    var delegate: WeatherManagerDelegate?
    
    //takes input of cityName and replaces city parameter in weatherURL sent to API
    //calls method in VC with cityName as parameter, looking for string arugment
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        //pass combined urlString
         //use self to call from current structure
        performRequest(with: urlString)
    }
    
    //
    //example URL = api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={your api key}
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        print(urlString)
    }

//perform networking to exchange info
func performRequest(with urlString: String) {
    
    //1. Create a URL
    //use URL initializer - here we use "if let" to optionally associate the URL created with cityName to constant url (as long as value exists)
    //optional because URL string might fail in response (typos)...
    if let url = URL(string: urlString) {
        
        //2. Create a URLSession
        //initialize standard URLSession object with default configuration
        let session = URLSession(configuration: .default)
        
        //Step 3:  Give URLSession a task
        //This will create a task to retreive contents of URL, then calls completion handler
        //Update to use trailing closure to complete if then below when complete dataTask
        let task = session.dataTask(with: url) { (data, response, error) in if error != nil {
            
            //if networking session fails (lose internet) - pass error back to delegate
            //self added b/c in closure
            self.delegate?.didFailWithError(error: error!)
            return //means exit out of function, don't do anything else
            }
            
            if let safeData = data {
                //error - need self
                //normally when call functions dont need to specify object who owned method to call it
               //optional binding for 'weather' output from parseJSON
                if let weather = self.parseJSON(safeData){
                    //self refers to the delegate in current WeatherManager class - (i.e. WeatherManagerDelegate above)
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
        
        //Step 4: Start the task
        //function called resume because begin in suspended state
        task.resume()
        
    }
}

//create function to parseJSON
//single input = weatherData as format of data returned from dataTask call
func parseJSON(_ weatherData: Data) -> WeatherModel? {
    //create a decoder
    let decoder = JSONDecoder()
    //1st input below = WeatherData struct type (not object). Use .self to reference the type.
    //2nd input below = WeatherData data type
    //Mark with try keyword so that can “throw” - if something goes wrong - can throw out error
    // wrap in do block to try running function
    do{
    // capture in constant "decodedData" to use decode output
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
        
        //create properties based on WeatherData properties to connect from API to WeatherModel
        //assigns id as constant from api id value
        let id = decodedData.weather[0].id
        let temp = decodedData.main.temp
        let name = decodedData.name
        
        //initialize weather object from WeatherModel struct with the unique properties we want to use from weatherModel
        let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
        return weather

    //create output from decode function
    //print name of weather symbol, when name of locaton entered
    //Calling function: weather ID is generic parameter, id is specific argument passed
    //access getConditionName by stepping back into weather / "WeatherModel"
        
        //just printing property that has already done the work within itself
        //print(weather.conditionName)
        //print(weather.temperatureString)
        
    //Use catch block to catch error if does occur.
    } catch {
        delegate?.didFailWithError(error: error)
        return nil
    }
}
        
}
