//
//  ProductResponse.swift
//  Capstone
//
//  Created by Xinran Che on 1/8/20.
//  Copyright © 2020 Xinran Che. All rights reserved.
//

import Foundation

enum ProductError:Error {
    case noDataAvailable
    case canNotProcessData
}

extension ProductError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noDataAvailable:
            return NSLocalizedString("Error! No available data! Check your internet connection!", comment: "No data available")
        case .canNotProcessData:
            return NSLocalizedString("Error! Something went wrong. Data cannot be processed.", comment: "Cannot process data")
        }
    }
}

struct ProductRequest {
    let resourceURL:URL
    init(barcode:String) {
        let resourceString = "https://api.upcitemdb.com/prod/trial/lookup?upc=\(barcode)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    func getProduct(completion: @escaping(Result<[ProductInfo], ProductError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let productResponse = try decoder.decode(ProductResponse.self, from: jsonData)
                let productInfo = productResponse.items
                completion(.success(productInfo))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
