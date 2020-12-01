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
    
    private var _restaurantDetail: RestaurantItemModel
    public var restaurantDetail: RestaurantItemModel {
        get {
            return _restaurantDetail
        }
        set(newValue) {
            _restaurantDetail = newValue
        }
    }
    
    
    private var restaurantDetailMenus: [RestaurantDailyMenus] = []
    
    // MARK: - Closures
    
    var updateTableView: ((Bool) -> ())?
    
    // MARK: - Constructor
    
    init(restaurantDetail: RestaurantItemModel, dataService: DataService) {
        self._restaurantDetail = restaurantDetail
        self.dataService = dataService
    }
    /*
    func getRestaurantDetail() -> RestaurantItemModel {
        return self.restaurantDetail
    }
    */
    public func checkDishes() -> [RestaurantDailyMenuDishes]  {
        guard let restaurantDetailMenus: RestaurantDailyMenus = self.restaurantDetailMenus.first else { return [] }
        guard let restaurantDetailMenu: RestaurantDailyMenu = restaurantDetailMenus.dailyMenu else { return [] }
        guard let dishes: [RestaurantDailyMenuDishes] = restaurantDetailMenu.dishes, !dishes.isEmpty else { return [] }
        return dishes
    }

    public func restaurantDailyMenus(for index: Int) -> RestaurantDailyMenuDish {
        guard let dish = checkDishes()[index].dish else { return RestaurantDailyMenuDish() }
        return dish
    }
    
    public func locationParameter() -> (latitude: Double, longitude: Double)? {
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
        guard let restaurantId = restaurantDetail.id else { return }
        let urlParameter: String = "dailymenu"
        var getParameter: String = ""
        getParameter += "?res_id=\(restaurantId)"
        
        dataService.sendRequestUniversal(urlParameter: urlParameter, getParameter: getParameter, postParameter: nil, RestaurantDetailMenu.self) { [weak self] (response) in
            guard let self = self else { return }
            if let restaurantDetailMenus = response.dailyMenus, !restaurantDetailMenus.isEmpty {
                self.restaurantDetailMenus.append(contentsOf: restaurantDetailMenus)
                self.updateTableView?(true)
            } else {
                self.updateTableView?(false)
            }
        } failHandler: { [weak self] (error) in
            guard let self = self else { return }
            debugPrint("error: ",error)
            self.updateTableView?(false)
        }
    }
}
