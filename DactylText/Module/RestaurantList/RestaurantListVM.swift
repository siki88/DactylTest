//
//  RRestaurantListVM.swift
//  DactylText
//
//  Created by Lukáš Spurný on 16/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit
import RealmSwift

final class RestaurantListVM: NSObject {
    
    // MARK: - Class properties
    
    private let dataService: DataService
    private let location: Location
    private let coordinator: RestaurantListCoordinator
    
    private var restaurantsList: [RestaurantModel]?
    
    // MARK: - Instance properties
    
    private let realDistance: String = "real_distance"
    private var startPage: Int = 0
    private let countItemTableView: Int = 20
    private var fetchingMore: Bool = false
    
    // MARK: - Closures
    
    var updateTableView: ((Bool) -> ())?
    
    // MARK: - Constructor
    
    required init(dataService: DataService, location: Location, coordinator: RestaurantListCoordinator) {
        self.dataService = dataService
        self.location = location
        self.coordinator = coordinator
        super.init()
        if Reachability.isConnectedToNetwork() {
            DispatchQueue.global(qos: .utility).async {
                self.removeAllRealmData()
            }
        }
    }
    
    func removeRestaurantsList() {
        self.restaurantsList = nil
    }
    
    func getFetchingMore() -> Bool {
        return fetchingMore
    }
    
    func setFetchingMore(_ fetchingMore: Bool) {
        self.fetchingMore = fetchingMore
    }
    
    func setStartPage(_ startPage: Int) {
        self.startPage = startPage
    }
    
    func getRestaurantsCount() -> Int {
        guard let restaurantsList = self.restaurantsList else { return 0 }
        return restaurantsList.count
    }
    
    func getRestaurantItem(_ indexPathRow: Int) -> RestaurantItemModel? {
        guard let restaurantsList = self.restaurantsList,
            let restaurant = restaurantsList[indexPathRow].restaurant
            else { return nil }
        return restaurant
    }
    
    func getRestaurantLocation(_ location: RestaurantLocationModel?) -> String {
        guard let location = location else { return "" }
        guard let locality = location.locality else { return "" }
        guard let city = location.city else { return "\(locality)" }
        return "\(locality), \(city)"
    }
    
    func getRestaurantRating(_ rating: RestaurantRatingModel?) -> CGFloat {
        guard let rating = rating else { return 0 }
        guard let aggregateRating = rating.aggregateRating else { return 0 }
        return CGFloat(aggregateRating.floatValue)
    }
    
    func redirectToRestaurantDetail(_ indexPathRow: Int) {
        let restaurantItem: RestaurantItemModel = getRestaurantItem(indexPathRow) ?? RestaurantItemModel()
        coordinator.startRestaurantDetail(restaurantItemModel: restaurantItem)
    }
}

// MARK: - Data Service and similary

extension RestaurantListVM {
    
    func fetchDataServiceRestaurantList(searchText: String?) {
        let urlParameter: String = "search"
        var getParameter: String = ""
        getParameter += "?start=\(startPage)"
        getParameter += "&count=\(countItemTableView)"
        
        if let searchText = searchText, searchText != "" {
            getParameter += "&q=\(searchText)"
        }
        
        if let latitude = self.location.getLatitude(), let longitude = self.location.getLongitude() {
            getParameter += "&sort=\(realDistance)"
            getParameter += "&lat=\(latitude)"
            getParameter += "&lon=\(longitude)"
        }
        
        dataService.sendRequestUniversal(urlParameter: urlParameter, getParameter: getParameter, postParameter: nil, RestaurantListModel.self) { [weak self] (response) in
            guard let self = self else { return }
            if let restaurantsList = response.restaurants, !restaurantsList.isEmpty {
                if self.restaurantsList == nil {
                    self.restaurantsList = restaurantsList
                } else {
                    self.restaurantsList?.append(contentsOf: restaurantsList)
                }
                
                DispatchQueue.global(qos: .utility).async {
                    self.setRealmData(restaurantsList: restaurantsList)
                }
                
                self.updateTableView?(true)
            }
        } failHandler: { [weak self] (error) in
            guard let self = self else { return }
            if !self.getRealmData().isEmpty {
                self.restaurantsList = self.getRealmData()
                self.updateTableView?(true)
            } else {
                self.updateTableView?(false)
            }
        }
    }
    
    func createImage(url: String?, completionHandler : @escaping (UIImage?) -> Void) {
        if let url = url, url != "" {
            DispatchQueue.global(qos: .userInitiated).async {
                self.dataService.responseUrlImage(url: url) { (result) in
                    DispatchQueue.main.async {
                        completionHandler(result)
                    }
                }
            }
        } else {
            completionHandler(UIImage(named: "iconRestaurant")) //Implements R.Swift
        }
    }
    
    func fetchScrollDataServiceRestaurantList(searchText: String?) {
        if !self.fetchingMore {
            self.fetchingMore = true
            self.startPage = self.startPage + self.countItemTableView
            fetchDataServiceRestaurantList(searchText: searchText)
        }
    }
}

// MARK: - Realm

extension RestaurantListVM {
    
    private func getRealmData() -> [RestaurantModel] {
        var restaurantModelArr: [RestaurantModel] = []
        do {
            let realm = try Realm()
            let restaurantItems = realm.objects(RestaurantItemModelRealm.self)
            
            for restaurantItem in restaurantItems {
                var restaurantModel: RestaurantModel = RestaurantModel()
                
                var restaurantItemModel: RestaurantItemModel = RestaurantItemModel()
                restaurantItemModel.apiKey = restaurantItem.apiKey
                restaurantItemModel.id = restaurantItem.id
                restaurantItemModel.name = restaurantItem.name
                restaurantItemModel.url = restaurantItem.url

                var restaurantLocationModel: RestaurantLocationModel = RestaurantLocationModel()
                restaurantLocationModel.locality  = restaurantItem.location?.locality
                restaurantLocationModel.city      = restaurantItem.location?.city
                restaurantLocationModel.latitude  = restaurantItem.location?.latitude
                restaurantLocationModel.longitude = restaurantItem.location?.longitude
                
                restaurantItemModel.cuisines = restaurantItem.cuisines
                restaurantItemModel.thumb = restaurantItem.thumb
                restaurantItemModel.photosUrl = restaurantItem.photosUrl
                
                var restaurantRatingModel: RestaurantRatingModel = RestaurantRatingModel()
                restaurantRatingModel.aggregateRating = restaurantItem.rating?.aggregateRating

                restaurantItemModel.location = restaurantLocationModel
                restaurantItemModel.rating = restaurantRatingModel
                restaurantModel.restaurant = restaurantItemModel
                restaurantModelArr.append(restaurantModel)
            }
        } catch {
            debugPrint("Couldn't create Realm")
        }
        return restaurantModelArr
    }
    
    private func setRealmData(restaurantsList: [RestaurantModel]) {
        do {
            let realm = try Realm()
            
            for restaurantsListItem in restaurantsList {
                guard let listItemRestaurant = restaurantsListItem.restaurant else { continue }
                let result = (realm.objects(RestaurantItemModelRealm.self).max(ofProperty: "idRealm") as Int? ?? 0) + 1
                let restaurantsListData = RestaurantItemModelRealm()
                restaurantsListData.idRealm = result
                restaurantsListData.apiKey  = listItemRestaurant.apiKey
                restaurantsListData.id      = listItemRestaurant.id
                restaurantsListData.name    = listItemRestaurant.name
                restaurantsListData.url     = listItemRestaurant.url
                if let listItemLocation     = listItemRestaurant.location {
                    let listItemLocationRealm = RestaurantLocationModelRealm()
                    listItemLocationRealm.locality  = listItemLocation.locality
                    listItemLocationRealm.city      = listItemLocation.city
                    listItemLocationRealm.latitude  = listItemLocation.latitude
                    listItemLocationRealm.longitude = listItemLocation.longitude
                    restaurantsListData.location    = listItemLocationRealm
                }
                restaurantsListData.cuisines  = listItemRestaurant.cuisines
                restaurantsListData.thumb     = listItemRestaurant.thumb
                restaurantsListData.photosUrl = listItemRestaurant.photosUrl
                if let listItemRating = listItemRestaurant.rating {
                    let listItemRatingRealm = RestaurantRatingModelRealm()
                    listItemRatingRealm.aggregateRating = listItemRating.aggregateRating
                    restaurantsListData.rating          = listItemRatingRealm
                }
                
                try? realm.write {
                    realm.add(restaurantsListData)
                }
            }
        } catch {
            debugPrint("Couldn't create Realm")
        }
    }
    
    private func removeAllRealmData() {
        do {
            let realm = try Realm()
            try? realm.write {
                realm.deleteAll()
            }
        } catch {
            debugPrint("Couldn't create Realm")
        }
    }
}
