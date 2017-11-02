//
//  OpenWeatherMapSerializer.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import Foundation

class OpenWeatherMapSerializer: WeatherProviderSerializer {

    // MARK: - Dictionary keys

    private let locationNameKey = "name"

    private let weatherDetailsKey = "main"
    private let currentTemperatureKey = "temp"
    private let minTemperatureKey = "temp_min"
    private let maxTemperatureKey = "temp_max"


    // MARK: - WeatherProviderSerializer implementation

    func deserialize(_ weatherData: Any) -> WeatherInfo? {
        guard let weatherData = weatherData as? [String: Any],
              let weatherDetails = weatherData[weatherDetailsKey] as? [String: Any] else {
            return nil
        }

        guard let locationName = weatherData[locationNameKey] as? String else {
            return nil
        }
        guard let currentTemperature = weatherDetails[currentTemperatureKey] as? Double else {
            return nil
        }
        guard let minTemperature = weatherDetails[minTemperatureKey] as? Double else {
            return nil
        }
        guard let maxTemperature = weatherDetails[maxTemperatureKey] as? Double else {
            return nil
        }

        return WeatherInfo(locationName: locationName, currentTemperature: currentTemperature,
                           minTemperature: minTemperature, maxTemperature: maxTemperature)
    }

}
