//
//  GoogleSearch.swift
//  Capstone
//
//  Created by Xinran Che on 1/14/20.
//  Copyright © 2020 Xinran Che. All rights reserved.
//

import Foundation

struct GoogleSearchResponse:Decodable {
    var results:[SearchResult]
}

struct SearchResult:Decodable {
    var image:String
    var title:String
    var source:String
    var link:String
}
