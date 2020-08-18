//
//  Navigation.swift
//  DactylText
//
//  Created by Lukáš Spurný on 16/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func makeColorNavigationBar () {
        barTintColor = UIColor.mainColor
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor.mainColor
          
            navBarAppearance.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.mainTextColor,
             NSAttributedString.Key.font: UIFont.mainFont(ofSize: 20)]
            
            navBarAppearance.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.mainTextColor,
             NSAttributedString.Key.font: UIFont.mainFont(ofSize: 20)]
 
            standardAppearance = navBarAppearance
            scrollEdgeAppearance = navBarAppearance
        }
    }
}
