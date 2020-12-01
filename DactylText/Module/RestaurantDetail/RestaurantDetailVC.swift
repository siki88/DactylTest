//
//  RestaurantDetailVC.swift
//  DactylText
//
//  Created by Lukáš Spurný on 16/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailVC: UIViewController {
    
    // MARK: - ViewModel
    
    private let viewModel: RestaurantDetailVM
    
    // MARK: - Class properties
    
    private var tableView = UITableView()
    private var mapView = MKMapView()

    // MARK: - Lifecycle
    
    init(viewModel: RestaurantDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        subscribeToViewModel()
        fetchDataServiceRestaurantDailyMenus()
    }

    private func configureVC() {
        configureNavigation()
        configureView()
        configureMapView()
        configureTableView()
    }
    
    private func configureNavigation() {
        //set view
        title = viewModel.restaurantDetail.name ?? ""
    }
    
    private func configureView() {
        view.backgroundColor = UIColor.backgroundColorWhite
    }
    
    private func configureMapView() {
        //set view
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
        //set setting
        mapView.delegate = self
        
        guard let location = viewModel.locationParameter() else { return }
        let latitude: Double = location.latitude
        let longitude: Double = location.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pin.title = viewModel.restaurantDetail.name ?? ""
        mapView.addAnnotation(pin)
    }
    
    private func configureTableView() {
        //set setting
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RestaurantDetailMenuTableViewCell.self, forCellReuseIdentifier: "restaurantDetailMenuCell")
        //tableView.separatorStyle = .none
        
        //set view
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func fetchDataServiceRestaurantDailyMenus() {
        view.showCustomActivityIndicator()
        DispatchQueue.global(qos: .userInitiated).async {
            self.viewModel.fetchDataServiceRestaurantMenu()
        }
    }
    
    private func subscribeToViewModel() {
        viewModel.updateTableView = { [weak self] (status) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.view.hideCustomActivityIndicator()
                self.tableView.reloadData()
            }
        }
    }
}

extension RestaurantDetailVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) { }
}

// MARK: - TableView method

extension RestaurantDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.checkDishes().count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Aktuální denní menu"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantDetailMenuCell") as? RestaurantDetailMenuTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = viewModel.restaurantDailyMenus(for: indexPath.row).name ?? ""
        cell.textLabel?.text? += " \(viewModel.restaurantDailyMenus(for: indexPath.row).price ?? "")"
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.font = UIFont.mainFont(ofSize: 14)
        return cell
    }
    

}
