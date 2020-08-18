//
//  View.swift
//  DactylText
//
//  Created by Lukáš Spurný on 17/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit

extension UIView {

    func showCustomActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: frame.size.width / 2, y: frame.size.height / 2, width: 27, height: 27))
        activityIndicator.color = UIColor.mainColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        isUserInteractionEnabled = false
    }

    func hideCustomActivityIndicator() {
        isUserInteractionEnabled = true
        for subview in subviews {
            if subview is UIActivityIndicatorView {
                subview.removeFromSuperview()
                break
            }
        }
    }
}
