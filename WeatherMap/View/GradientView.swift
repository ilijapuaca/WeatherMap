//
//  GradientView.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable
    var startColor: UIColor?

    @IBInspectable
    var endColor: UIColor?

    /// Internal gradient layer variable.
    private var gradientLayer: CAGradientLayer?

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Update the gradient layer frame
        gradientLayer?.frame = bounds
    }

    // MARK: - Utility methods

    private func setupGradient() {
        let colors = [startColor ?? UIColor(red: 90.0 / 255.0, green: 155.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0),
                      endColor ?? UIColor.white]

        gradientLayer = CAGradientLayer()
        gradientLayer!.colors = colors.map({ return $0.cgColor })
        gradientLayer!.locations = [0.0, 1.0]
        gradientLayer!.frame = bounds

        // Add as the first sublayer so that it doesn't cover subviews
        layer.insertSublayer(gradientLayer!, at: 0)
    }

}
