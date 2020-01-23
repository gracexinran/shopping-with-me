//
//  GoogleSearchRequest.swift
//  Capstone
//
//  Created by Xinran Che on 1/14/20.
//  Copyright © 2020 Xinran Che. All rights reserved.
//

import Foundation

enum SearchError:Error {
    case noDataAvailable
    case canNotProcessData
}

extension SearchError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noDataAvailable:
            return NSLocalizedString("Error! No available data! Check your internet connection!", comment: "No data available")
        case .canNotProcessData:
            return NSLocalizedString("Error! Something went wrong. Data cannot be processed.", comment: "Cannot process data")
        }
    }
}

struct GoogleSearchRequest {
    let request:URLRequest
    init(searchTerm:String, start:Int) {
        let resourceString = "https://ejhjq1dl9d.execute-api.us-east-2.amazonaws.com/live/recognition-ruby"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        let json: [String: Any] = ["searchTerm": searchTerm, "start": start]
        let jsonBody = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: resourceURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        request.httpMethod = "POST"
        self.request = request
    }
    
    func getSearchResults(completion: @escaping(Result<[SearchResult], SearchError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(GoogleSearchResponse.self, from: jsonData)
                let searchResults = searchResponse.results
                completion(.success(searchResults))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
