//
//  WeatherMapTests.swift
//  WeatherMapTests
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import XCTest
import MapKit
@testable import WeatherMap

class WeatherMapTests: XCTestCase {

    func testWeatherInfoCache() {
        let userDefaults = UserDefaults()
        let weatherInfoCache = WeatherInfoCache(userDefaults: userDefaults)

        let coordinates = CLLocationCoordinate2D(latitude: 44.82, longitude: 22.123)
        let weatherInfo = WeatherInfo(location: coordinates, locationName: "Test", currentTemperature: 11.11, minTemperature: 22.22, maxTemperature: 33.33)
        weatherInfoCache.add(weatherInfo)

        let retrievedWeatherInfo = weatherInfoCache.retrieve(location: coordinates)
        XCTAssertNotNil(retrievedWeatherInfo, "WeatherInfo instance should not be nil as it exists in cache")
    }

}
