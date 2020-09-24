//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

//adopts WeatherManagerDelegate protocol
class WeatherViewController: UIViewController { //this allows class to manage editing / validation in text field
    //

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func currentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
     }

    //connects VC to WeatherManager model
    var weatherManager = WeatherManager()
    
    //creates 'locationManager' object to connect VC to Core Location Manager class
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //sets WeatherVC as delegate for locationManager
        locationManager.delegate = self
        //prompts request for user's location. Allows user to specify when to share
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //tap into delegate then set as current class using self
        //text field should report back to view controller. The text field notifies VC when user changes text field (starting typing, stopped typing)
        // Ensure textfield notifies VC. Set textfield as delegate.
        //Self refers to current view controller
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate

//move in all parts of code that relate to textfield into extension
extension WeatherViewController: UITextFieldDelegate {
        @IBAction func searchPressed(_ sender: UIButton) {
              //print(searchTextField.text!)
              searchTextField.endEditing(true) //tells search field we are done with editing, dismiss the keyboard
          }
          
          //when user hits return - run this code
          func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              //print(searchTextField.text!)
              searchTextField.endEditing(true) //we are done with editing, dismiss the keyboard
              return true
          }
          
          // text field asks VC what to do when user taps off the text field
          // useful for validation on what user types, therefore useful to trap in editing mode when tap off text field
          // validation is test if user enters nothing, enters something that doesn't match expected result, etc.
          func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
              //refer to generic textField - b/c textField class responsible to pass unique "UITextField" to apply code to. There can be multiple textFields, similar to multiple Senders
              if textField.text != "" { //check that user types something
                  return true
              } else {
                  textField.placeholder = "Please Type something" //remind user they need to type something in the text field
                  return false
              }
          }
          
          
          //text field telling VC that the user stopped editing
          //allows for any functions to occur based on entry in text field
          //textFieldDidEndEditing resets text field
          func textFieldDidEndEditing(_ textField: UITextField) {
              
              //assign searchTextField.text to city which will get weather for city searched by user
              //since text field is optional and def want to pass to model, use "if let" to optionally unwrap if value
              if let city = searchTextField.text {
                  //call fetchWeather function and pass city in argument for cityName
                  weatherManager.fetchWeather(cityName: city)
              }
              
              searchTextField.text = "" //clear any text from search bar and reset text field
          }
}

//MARK: - WeatherManagerDelegate

//move 2 weatherManagerDelegate related methods to here
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather (_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            //set temp label on UI to be equal to temperature returned
            // dispatchqueue is closure, so add self
            self.temperatureLabel.text=weather.temperatureString
            //set weather conditon icon to SFsymbol condition string from weathermodel
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text=weather.cityName
            
        }
        
        print(weather.temperature)
        print(weather.cityName)
        print(weather.conditionName)

    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    //triggered by requestLocation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //LocationManager will get multiple current GPS locations, using the last will give us most accuracy
       
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            //calls fetchWeather to add in lat, lon from current location
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
