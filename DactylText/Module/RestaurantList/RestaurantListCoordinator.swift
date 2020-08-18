//
//  RestaurantListCoordinator.swift
//  DactylText
//
//  Created by Lukáš Spurný on 18/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit

class RestaurantListCoordinator {

    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startRestaurantDetail(restaurantItemModel: RestaurantItemModel) {
        let restaurantDetailVM: RestaurantDetailVM = RestaurantDetailVM(restaurantDetail: restaurantItemModel, dataService: DataService())
        let restaurantDetailVC: RestaurantDetailVC = RestaurantDetailVC(viewModel: restaurantDetailVM)
        navigationController.pushViewController(restaurantDetailVC, animated: true)
    }
}
