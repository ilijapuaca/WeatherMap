//
//  OpenWeatherMapNetworkUtility.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import Foundation

/// OpenWeatherMap specific weather provider network utility.
class OpenWeatherMapNetworkUtility: WeatherProviderNetworkUtility {

    /// Base url for the weather API.
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

    /// String to be added to the end of the request URL.
    private let apiKeyPostfix = "&APPID=b20f893f8b653c2914c561f326ddfb14"

    // MARK: - WeatherProviderNetworkUtility implementation
    
    /// TODO: Kind of a gimmic, rethink this.
    var apiToken: String? {
        return nil
    }

    func weatherUrl(lat: Double, lon: Double) -> String {
        return String(format: "%@?lat=%f&lon=%f%@", baseUrl, lat, lon, apiKeyPostfix)
    }

}
