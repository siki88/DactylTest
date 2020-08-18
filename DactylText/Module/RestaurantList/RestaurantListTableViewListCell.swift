//
//  RestaurantListTableViewListCell.swift
//  DactylText
//
//  Created by Lukáš Spurný on 16/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class RestaurantListTableViewListCell: UITableViewCell {
    
    public let thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoView: UIView = {
    let view = UIView()
        return view
    }()
    
    public let productNameLabel: UILabel = {
    let lbl = UILabel()
        lbl.textColor = UIColor.mainTextColor
        lbl.font = UIFont.mainFont(ofSize: 20)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public let productDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.mainTextColor
        lbl.font = UIFont.mainFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public let productLocationLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.mainTextColor
        lbl.font = UIFont.mainFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public let starRatingView: SwiftyStarRatingView = {
        let starRatingView = SwiftyStarRatingView()
        starRatingView.maximumValue = 5
        starRatingView.minimumValue = 0
        starRatingView.allowsHalfStars = true
        starRatingView.isEnabled = false
        starRatingView.tintColor = UIColor.mainColor
        return starRatingView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews(frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addViews(_ frame: CGRect){
        
        addSubview(thumbImageView)
        thumbImageView.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(10)
            make.rightMargin.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerY.equalToSuperview()
        }
        
        addSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(thumbImageView.snp.right).offset(10)
        }
        
        infoView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(infoView.snp.top).offset(10)
            make.right.equalTo(infoView.snp.right)
            make.left.equalTo(infoView.snp.left).offset(10)
            make.height.equalTo(25)
        }
        
        infoView.addSubview(productDescriptionLabel)
        productDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productNameLabel.snp.bottom).offset(5)
            make.right.equalTo(infoView.snp.right)
            make.left.equalTo(infoView.snp.left).offset(10)
            make.height.equalTo(20)
        }
        
        infoView.addSubview(productLocationLabel)
        productLocationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productDescriptionLabel.snp.bottom).offset(5)
            make.right.equalTo(infoView.snp.right)
            make.left.equalTo(infoView.snp.left).offset(10)
            make.height.equalTo(20)
        }
        
        infoView.addSubview(starRatingView)
        starRatingView.snp.makeConstraints { (make) in
            make.top.equalTo(productLocationLabel.snp.bottom).offset(5)
            make.left.equalTo(infoView.snp.left).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(150)
        }
    }
}
