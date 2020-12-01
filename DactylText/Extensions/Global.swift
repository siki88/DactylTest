//
//  Global.swift
//  DactylText
//
//  Created by Lukáš Spurný on 16/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit

extension UIFont {
    
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func mainFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "TimesNewRomanPS-BoldMT", size: size)
    }
}

extension UIColor {
    static var mainColor = UIColor(red: 218/255, green: 055/255, blue: 050/255, alpha: 1.0)
    static var mainTextColor = UIColor.black
    static var backgroundColorWhite = UIColor.white
}

extension String {
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
