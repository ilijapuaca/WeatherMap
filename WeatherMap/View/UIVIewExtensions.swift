//
//  UIVIewExtensions.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit

/// General UIView utilities.
extension UIView {

    /// Adds a subview that'll take up the entire frame of the view.
    ///
    /// - Parameter view: View to add
    func addFillerSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let views = ["view": view]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)

        NSLayoutConstraint.activate(constraints)
    }

    /// Loads a view from xib file named same as the invoking class.
    ///
    /// - Returns: Newly created UIView instance.
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }

}
