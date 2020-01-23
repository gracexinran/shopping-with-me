//
//  Product.swift
//  Capstone
//
//  Created by Xinran Che on 1/8/20.
//  Copyright © 2020 Xinran Che. All rights reserved.
//

import Foundation

struct ProductResponse:Decodable {
    var items:[ProductInfo]
}

struct ProductInfo:Decodable {
    var title:String
    var images:[String]
    var offers:[Offer]
}

struct Offer:Decodable {
    var merchant:String
    var price:Double
    var link:String
}

