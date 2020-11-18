//
//  RestaurantListVC.swift
//  DactylText
//
//  Created by Lukáš Spurný on 16/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit
import SnapKit

class RestaurantListVC: UIViewController {
    
    // MARK: - ViewModel
    
    private let viewModel: RestaurantListVM
    
    // MARK: - Class properties
    
    private var tableView = UITableView()
    
    private lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: RestaurantListVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        subscribeToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchDataServiceRestaurantList()
    }
    
    private func configureVC() {
        configureNavigation()
        configureView()
        configureSearchBar()
        configureTableView()
    }
    
    private func configureNavigation() {
        //set view
        title = "Restaurant"
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.makeColorNavigationBar()
    }
    
    private func configureView() {
        //set view
        self.view.backgroundColor = UIColor.green
    }
    
    private func configureSearchBar() {
        //set view
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func configureTableView() {
        //set setting
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RestaurantListTableViewListCell.self, forCellReuseIdentifier: "restaurantListCell")
        tableView.separatorStyle = .none
        
        //set view
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(0)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func subscribeToViewModel() {
        viewModel.updateTableView = { [weak self] (status) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                //self.view.hideCustomActivityIndicator()
                if status {
                    self.tableView.reloadData()
                    if self.viewModel.getFetchingMore() {
                        self.viewModel.setFetchingMore(false)
                    }
                }
            }
        }
    }
    
    private func fetchDataServiceRestaurantList() {
        //view.showCustomActivityIndicator()
        DispatchQueue.global(qos: .userInitiated).async {
            self.viewModel.fetchDataServiceRestaurantList(searchText: nil)
        }
    }
}

// MARK: - Scroll method

extension RestaurantListVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY >= contentHeight - scrollView.frame.height {
            viewModel.fetchScrollDataServiceRestaurantList(searchText: self.searchBar.text)
        }
    }
}

// MARK: - TableView method

extension RestaurantListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRestaurantsCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantListCell") as? RestaurantListTableViewListCell else { return UITableViewCell() }
        //Implement to ViewModel
        guard let item = viewModel.getRestaurantItem(indexPath.row) else { return UITableViewCell() }
        //Implement to ViewModel
        cell.productNameLabel.text = item.name ?? ""
        cell.productDescriptionLabel.text = item.cuisines ?? ""
        cell.productLocationLabel.text = viewModel.getRestaurantLocation(item.location)
        cell.starRatingView.value = viewModel.getRestaurantRating(item.rating)

        self.viewModel.createImage(url: item.thumb) { [weak self] (image) in
            guard self != nil else { return }
            cell.thumbImageView.image = image
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.redirectToRestaurantDetail(indexPath.row)
    }
}

// MARK: - SearchBar method

extension RestaurantListVC: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        viewModel.setStartPage(0)
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        fetchDataServiceOnSearchBar(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        fetchDataServiceOnSearchBar(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
    }
    
    private func fetchDataServiceOnSearchBar(_ searchBar: UISearchBar) {
        viewModel.removeRestaurantsList()
        viewModel.fetchDataServiceRestaurantList(searchText: searchBar.text)
    }
}
