//
//  ViewController.swift
//  Weather App
//
//  Created by Piotr Kędra on 26/10/2019.
//  Copyright © 2019 Piotr Kędra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var currentTempField: UITextField!
    @IBOutlet weak var statField: UITextField!
    @IBOutlet weak var minMaxField: UITextField!
    
    @IBOutlet weak var windSpeedLabel: UITextField!
    @IBOutlet weak var windSpeedField: UITextField!
    @IBOutlet weak var windDirectionLabel: UITextField!
    @IBOutlet weak var windDirectionField: UITextField!
    @IBOutlet weak var airPreassureLabel: UITextField!
    @IBOutlet weak var airPreassureField: UITextField!
    @IBOutlet weak var humidityLabel: UITextField!
    @IBOutlet weak var himidityField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    
    var days:[WeatherDay] = []
    var dayIndex = 0
    var quantityOfDays = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationField.text = "London"
        windSpeedLabel.text = "Wind speed:"
        windDirectionLabel.text = "Wind direction:"
        airPreassureLabel.text = "Air preassure:"
        humidityLabel.text = "Humidity:"
        
        loadWeatherInformation()
    }
    
    func updateWeatherUI(dayData : WeatherDay) -> Void {
        dateField.text = dayData.applicable_date
        
        windSpeedField.text = String(round(dayData.wind_speed))
        windDirectionField.text = String(dayData.wind_direction_compass)
        airPreassureField.text = String(round(dayData.air_pressure))
        himidityField.text = String(dayData.humidity)
        
        currentTempField.text = roundTemp(temp: dayData.temp)
        statField.text = dayData.weather_state_name
        minMaxField.text = roundTemp(temp: dayData.min_temp) + "/" + roundTemp(temp: dayData.max_temp)
        
        let url = URL(string: getStateImage(abbr: dayData.weather_state_abbr))!
        downloadImage(from: url)
    }
    
    func getStateImage(abbr : String) -> String{
        return "https://www.metaweather.com/static/img/weather/png/" + abbr + ".png"
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.stateImage.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    @IBAction func nextOnClick(_ sender: Any) {
        dayIndex = dayIndex + 1
        if(dayIndex == quantityOfDays - 1){
            nextButton.isEnabled = false
        }
        updateWeatherUI(dayData: days[dayIndex])
        if(!prevButton.isEnabled){
            prevButton.isEnabled = true
        }
    }
    @IBAction func prevOnClick(_ sender: Any) {
        print("AAAAA:")
        print(days.count)
        print(dayIndex)
        if(!nextButton.isEnabled){
            nextButton.isEnabled = true
        }
        dayIndex = dayIndex - 1
        if(dayIndex == 0){
            prevButton.isEnabled = false
        }
        updateWeatherUI(dayData: days[dayIndex])
    }
    
    func roundTemp(temp: Double) -> String{
        return String(Int(round(temp))) + "°C"
    }

    func loadWeatherInformation() -> Void {
        let url = URL(string: "https://www.metaweather.com/api/location/44418")!
        
        // create task to make asynchronous API call
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            // check if request return type is set to json (return otherwise)
            guard let mime = response!.mimeType, mime == "application/json" else {return}
            
            // deserialize json object into an array of WeatherDay
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                if let dictionary = json as? [String : Any] {
                    
                    // save weather information for a next few days in array
                    self.days = parseWeahterData(dictionary: dictionary)
                    self.quantityOfDays = self.days.count
                    // UI update needs to be called from main thread
                    DispatchQueue.main.async {
                        self.updateWeatherUI(dayData: self.days[self.dayIndex])
                   }
                }
            }
        }
        task.resume()
    }
    
    
}

