//
//  WeatherProviderNetworkUtility.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import Foundation

/// Protocol that contains utility network parameters for a weather provider.
protocol WeatherProviderNetworkUtility {

    var apiToken: String? { get }

    func weatherUrl(lat: Double, lon: Double) -> String

}
