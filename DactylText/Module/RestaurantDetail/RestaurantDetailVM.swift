//
//  RestaurantDetailVM.swift
//  DactylText
//
//  Created by Lukáš Spurný on 17/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit

final class RestaurantDetailVM {
    
    // MARK: - Class properties
    
    private let dataService: DataService
    
    private let restaurantDetail: RestaurantItemModel
    private var restaurantDetailMenus: [RestaurantDailyMenus] = []
    
    // MARK: - Closures
    
    var updateTableView: ((Bool) -> ())?
    
    // MARK: - Constructor
    
    init(restaurantDetail: RestaurantItemModel, dataService: DataService) {
        self.restaurantDetail = restaurantDetail
        self.dataService = dataService
    }
    
    func getRestaurantDetail() -> RestaurantItemModel {
        return self.restaurantDetail
    }
    
    private func checkDishes() -> [RestaurantDailyMenuDishes]  {
        guard let restaurantDetailMenus: RestaurantDailyMenus = self.restaurantDetailMenus.first else { return [] }
        guard let restaurantDetailMenu: RestaurantDailyMenu = restaurantDetailMenus.dailyMenu else { return [] }
        guard let dishes: [RestaurantDailyMenuDishes] = restaurantDetailMenu.dishes, !dishes.isEmpty else { return [] }
        return dishes
    }
    
    func getRestaurantDailyMenusCount() -> Int {
        return checkDishes().count
    }
    
    func getRestaurantDailyMenus(indexPathRow: Int) -> RestaurantDailyMenuDish {
        guard let dish = checkDishes()[indexPathRow].dish else { return RestaurantDailyMenuDish() }
        return dish
    }
    
    func getLocationParameter() -> (latitude: Double, longitude: Double)? {
        guard let location = self.restaurantDetail.location,
            let latitude = location.latitude,
            let longitude = location.longitude
            else { return nil }
        return (latitude: Double(latitude), longitude: Double(longitude)) as? (latitude: Double, longitude: Double)
    }
}

// MARK: - Data Service and similary

extension RestaurantDetailVM {
    
    func fetchDataServiceRestaurantMenu() {
        guard let restaurantId = getRestaurantDetail().id else { return }
        let urlParameter: String = "dailymenu"
        var getParameter: String = ""
        getParameter += "?res_id=\(restaurantId)"
        
        dataService.menuRequest(urlParameter: urlParameter, getParameter: getParameter, postParameter: nil) { (response, error) in
            if let error = error {
                debugPrint("error: ",error)
                self.updateTableView?(false)
            }
            if let response = response {
                debugPrint("response: ",response)
                if let restaurantDetailMenus = response.dailyMenus, !restaurantDetailMenus.isEmpty {
                    self.restaurantDetailMenus.append(contentsOf: restaurantDetailMenus)
                    self.updateTableView?(true)
                } else {
                    self.updateTableView?(false)
                }
            }
        }
    }
}
