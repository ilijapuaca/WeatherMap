//
//  OpenWeatherMap.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import Foundation

class OpenWeatherMap: WeatherProvider {

    var networkUtility: WeatherProviderNetworkUtility {
        // TODO: These should be cached
        return OpenWeatherMapNetworkUtility()
    }

    var serializer: WeatherProviderSerializer {
        // TODO: These should be cached
        return OpenWeatherMapSerializer()
    }

}
