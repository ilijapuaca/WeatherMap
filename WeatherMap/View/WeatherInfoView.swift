//
//  WeatherInfoView.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit

/// View that shows relevant data set to WeatherInfo object.
class WeatherInfoView: UIView {

    // MARK: - Properties

    private let measurementFormatter: MeasurementFormatter = {
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.locale = NSLocale.current
        measurementFormatter.unitStyle = .medium
        measurementFormatter.numberFormatter.maximumFractionDigits = 0

        return measurementFormatter
    }()

    // MARK: - Outlets

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    private func setUpView() {
        let view = loadViewFromNib()
        addFillerSubview(view)

        layer.cornerRadius = 10.0
        layer.masksToBounds = true
    }

    // MARK: - Utility methods

    /// Shows data contained in weatherInfo.
    ///
    /// - Parameter weatherInfo: WeatherInfo object for which to show the data for
    func show(weatherInfo: WeatherInfo) {
        locationLabel.text = weatherInfo.locationName
        currentTemperatureLabel.text = measurementFormatter.string(from: weatherInfo.currentTemperature)
        minimumTemperatureLabel.text = measurementFormatter.string(from: weatherInfo.minTemperature)
        maximumTemperatureLabel.text = measurementFormatter.string(from: weatherInfo.maxTemperature)
    }

}
