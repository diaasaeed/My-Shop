//
//  ProductsAPI.swift
//  TRU Assignment
//
//  Created by Diaa saeed on 07/08/2025.
//

import Foundation
import Moya

enum ProductsAPI: APIEndpoint {
    case getProducts(limit: Int)
    
    var baseURL: URL {
        return URL(string: "https://fakestoreapi.com")!
    }
    
    var path: String {
        switch self {
        case .getProducts:
            return "/products"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProducts:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getProducts(let limit):
            let parameters: [String: Any] = [
                "limit": limit
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
} 
