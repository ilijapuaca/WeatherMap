//
//  OpenWeatherMapSerializer.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import Foundation
import MapKit

/// OpenWeatherMap specific weather provider serializer.
class OpenWeatherMapSerializer: WeatherProviderSerializer {

    // MARK: - Dictionary keys

    private let locationNameKey = "name"

    private let coordinatesDetailsKey = "coord"
    private let coordinateLatitudeKey = "lat"
    private let coordinateLongitudeKey = "lon"

    private let weatherDetailsKey = "main"
    private let currentTemperatureKey = "temp"
    private let minTemperatureKey = "temp_min"
    private let maxTemperatureKey = "temp_max"

    // MARK: - WeatherProviderSerializer implementation

    func deserialize(_ weatherData: Any) -> WeatherInfo? {
        guard let weatherData = weatherData as? [String: Any],
              let weatherDetails = weatherData[weatherDetailsKey] as? [String: Any],
              let coordinateDetails = weatherData[coordinatesDetailsKey] as? [String: Double]
            else { return nil }

        guard let coordinatesLatitude = coordinateDetails[coordinateLatitudeKey],
              let coordinatesLongitude = coordinateDetails[coordinateLongitudeKey],
              let locationName = weatherData[locationNameKey] as? String,
              let currentTemperature = weatherDetails[currentTemperatureKey] as? Double,
              let minTemperature = weatherDetails[minTemperatureKey] as? Double,
              let maxTemperature = weatherDetails[maxTemperatureKey] as? Double
        else { return nil }

        let location = CLLocationCoordinate2D(latitude: coordinatesLatitude, longitude: coordinatesLongitude)
        return WeatherInfo(location: location, locationName: locationName, currentTemperature: currentTemperature,
                           minTemperature: minTemperature, maxTemperature: maxTemperature)
    }

}
