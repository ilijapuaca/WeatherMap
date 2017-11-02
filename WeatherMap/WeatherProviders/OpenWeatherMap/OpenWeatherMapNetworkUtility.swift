//
//  OpenWeatherMapNetworkUtility.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import Foundation

class OpenWeatherMapNetworkUtility: WeatherProviderNetworkUtility {

    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

    private let apiKeyPostfix = "&APPID=b20f893f8b653c2914c561f326ddfb14"

    var apiToken: String? {
        return nil
    }

    func weatherUrl(lat: Double, lon: Double) -> String {
        return String(format: "%@?lat=%f&lon=%f%@", baseUrl, lat, lon, apiKeyPostfix)
    }

}
