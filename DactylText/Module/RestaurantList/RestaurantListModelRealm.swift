//
//  RestaurantListModelRealm.swift
//  DactylText
//
//  Created by Lukáš Spurný on 18/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit
import RealmSwift

final class RestaurantItemModelRealm: Object {
    @objc dynamic var idRealm: Int = 0
    @objc dynamic var apiKey: String?
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var url: String?
    @objc dynamic var location: RestaurantLocationModelRealm?
    @objc dynamic var cuisines: String?
    @objc dynamic var thumb: String?
    @objc dynamic var photosUrl: String?
    @objc dynamic var rating: RestaurantRatingModelRealm?
}

final class RestaurantLocationModelRealm: Object {
    @objc dynamic var locality: String?
    @objc dynamic var city: String?
    @objc dynamic var latitude: String?
    @objc dynamic var longitude: String?
}

final class RestaurantRatingModelRealm: Object {
    @objc dynamic var aggregateRating: String?
}
