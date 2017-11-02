//
//  WeatherNetworkManager.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

// MARK: - Utility block declarations

typealias WeatherInfoFetchClosure = (WeatherInfo?, Error?) -> Void

/// Utility class that performs network operations.
class WeatherNetworkManager {

    /// Provider that'll be used to retrieve weather data.
    let weatherProvider = OpenWeatherMap()

    /// Session manager that'll be used for networking operations.
    private lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default

        // If weather provider requires an API token, this could be useful as it could set one
        // automatically based on network utility implementation
        if let apiToken = self.weatherProvider.networkUtility.apiToken {
            var additionalHeaders = SessionManager.defaultHTTPHeaders
            // TODO: Should header name be pulled out of network utility implementation too?
            additionalHeaders["Token"] = apiToken

            // Do any other provider-specific setup here

            configuration.httpAdditionalHeaders = additionalHeaders
        }

        return SessionManager(configuration: configuration)
    }()

    // MARK: - API calls

    /// Fetches current weather data for coordiante.
    ///
    /// - Parameters:
    ///   - coordinate: Coordinate to fetch the weather data for
    ///   - handler:    Closure that'll be called once response arrives
    func fetchWeatherInfo(coordinate: CLLocationCoordinate2D, handler: @escaping WeatherInfoFetchClosure) {
        let fetchUrl = weatherProvider.networkUtility.weatherUrl(lat: coordinate.latitude, lon: coordinate.longitude)
        sessionManager.request(fetchUrl).validate().responseJSON { [weak self] response in
            guard let `self` = self else {
                return
            }

            switch response.result {
            case .success(let value):
                let serializer = self.weatherProvider.serializer
                if let weatherInfo = serializer.deserialize(value) {
                    handler(weatherInfo, nil)
                } else {
                    // TODO: We'd like to have our own Error implementation that would contain appropriate domain/codes
                    // Pass a super generic error back to indicate something went wrong
                    handler(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))
                }
            case .failure(let error):
                // TODO: We'd like to have our own Error implementation that would contain appropriate domain/codes
                handler(nil, error)
            }
        }
    }

}
