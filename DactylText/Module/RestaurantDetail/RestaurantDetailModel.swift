//
//  RestaurantDetailModel.swift
//  DactylText
//
//  Created by Lukáš Spurný on 17/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit

struct RestaurantDetailMenu: Decodable & Codable {
    var dailyMenus: [RestaurantDailyMenus]?
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case dailyMenus = "daily_menus"
        case status = "status"
    }
}

struct RestaurantDailyMenus: Decodable & Codable {
    var dailyMenu: RestaurantDailyMenu?

    enum CodingKeys: String, CodingKey {
        case dailyMenu = "daily_menu"
    }
}

struct RestaurantDailyMenu: Decodable & Codable {
    var dailyMenuId: String?
    var startDate: String?
    var endDate: String?
    var name: String?
    var dishes: [RestaurantDailyMenuDishes]?

    enum CodingKeys: String, CodingKey {
        case dailyMenuId = "daily_menu_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case name = "name"
        case dishes = "dishes"
    }
}

struct RestaurantDailyMenuDishes: Decodable & Codable {
    var dish: RestaurantDailyMenuDish?

    enum CodingKeys: String, CodingKey {
        case dish = "dish"
    }
}

struct RestaurantDailyMenuDish: Decodable & Codable {
    var dishId: String?
    var name: String?
    var price: String?

    enum CodingKeys: String, CodingKey {
        case dishId = "dish_id"
        case name = "name"
        case price = "price"
    }
}

