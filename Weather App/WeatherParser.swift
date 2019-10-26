//
//  WeatherParser.swift
//  Weather App
//
//  Created by Piotr Kędra on 26/10/2019.
//  Copyright © 2019 Piotr Kędra. All rights reserved.
//

import Foundation


func parseWeahterData(dictionary : [String : Any]) -> [WeatherDay] {
    var weatherDays = [WeatherDay]()
    if let array = dictionary["consolidated_weather"] as? [Any] {
        for day_object in array{
            if let day = day_object as? [String: Any]{
                var tmp: WeatherDay = WeatherDay()
                print(day)
                tmp.weather_state_name = day["weather_state_name"] as! String
                tmp.weather_state_abbr = day["weather_state_abbr"] as! String
                tmp.wind_direction_compass = day["wind_direction_compass"] as! String
                tmp.wind_speed = day["wind_speed"] as! Double
                tmp.temp = day["the_temp"] as! Double
                tmp.min_temp = day["min_temp"] as! Double
                tmp.max_temp = day["max_temp"] as! Double
                tmp.air_pressure = day["air_pressure"] as! Double
                tmp.applicable_date = day["applicable_date"] as! String
                tmp.humidity = day["humidity"] as! Int
        
                weatherDays.append(tmp)
            }
        }
    }
    
    return weatherDays
}
