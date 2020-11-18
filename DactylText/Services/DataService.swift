//
//  DataService.swift
//  DactylText
//
//  Created by Lukáš Spurný on 16/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

struct DataService {
    
    // MARK: - Singleton
    static let shared = DataService()
    
    // MARK: - URL
    private let baseUrl: String = "https://developers.zomato.com/api/v2.1/"
    private let userKey: String = "2b3a8c2baa6d953047bc375668d2988a"

    // MARK: - Services
    
    public func sendRequestUniversal<T:Codable>(urlParameter: String?, getParameter: String?, postParameter: [String: Any]?,_ type :T.Type, successHandler:@escaping(T)->(), failHandler:@escaping(Error)->()) {
        
        let headers: HTTPHeaders = [
            "user-key": "\(self.userKey)",
            "Accept": "application/json"
        ]
        let method: HTTPMethod = .get
        var urlString = self.baseUrl
        if let urlParameter = urlParameter {
            urlString += urlParameter
        }
        if let getParameter = getParameter {
            urlString += getParameter
        }
        guard let convertUrl = URL(string: urlString) else { return }
        
        AF.request(convertUrl, method: method, parameters: postParameter, encoding: URLEncoding.default, headers: headers, interceptor: nil).responseDecodable { (response:AFDataResponse<T>) in
            switch response.result{
            case .success(let responseEvent):
                successHandler(responseEvent)
            case .failure(let error):
                failHandler(error)
            }
        }
    }
    
    func responseUrlImage(url: String, completionHandler : @escaping (UIImage?) -> Void) {
        AF.request(url, method: .get).responseImage { response in
            if let imageData = response.data {
                let image = UIImage(data: imageData)
                completionHandler(image)
             }
        }
    }
}
