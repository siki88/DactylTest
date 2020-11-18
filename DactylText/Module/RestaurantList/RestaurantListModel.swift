//
//  RestaurantListModel.swift
//  DactylText
//
//  Created by Lukáš Spurný on 16/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit

struct RestaurantListModel: Decodable & Codable {
    var resultsFound: Int?
    var resultsStart: Int?
    var resultsShown: Int?
    var restaurants: [RestaurantModel]?
    
    enum CodingKeys: String, CodingKey {
        case resultsFound = "results_found"
        case resultsStart = "results_start"
        case resultsShown = "results_shown"
        case restaurants = "restaurants"
    }
}

struct RestaurantModel: Decodable & Codable {
    var restaurant: RestaurantItemModel?
    
    enum CodingKeys: String, CodingKey {
        case restaurant = "restaurant"
    }
}

struct RestaurantItemModel: Decodable & Codable {
    var apiKey: String?
    var id: String?
    var name: String?
    var url: String?
    var location: RestaurantLocationModel?
    var cuisines: String?
    var thumb: String?
    var photosUrl: String?
    var rating: RestaurantRatingModel?
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "apikey"
        case id = "id"
        case name = "name"
        case url = "url"
        case location = "location"
        case cuisines = "cuisines"
        case thumb = "thumb"
        case photosUrl = "photos_url"
        case rating = "user_rating"
    }
}

struct RestaurantLocationModel: Decodable & Codable {
    var locality: String?
    var city: String?
    var latitude: String?
    var longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case locality = "locality"
        case city = "city"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}

struct RestaurantRatingModel: Decodable & Codable {
    var aggregateRating: String?
    
    enum CodingKeys: String, CodingKey {
        case aggregateRating = "aggregate_rating"
    }
    
    init(aggregateRating: String? = nil) {
        self.aggregateRating = aggregateRating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            aggregateRating = try container.decode(String.self, forKey: .aggregateRating)
        } catch DecodingError.typeMismatch {
            aggregateRating = try String(container.decode(Int.self, forKey: .aggregateRating))
        }
    }
}
