//
//  City.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 4.2.2021.
//

import Foundation

struct City: Codable {
    var data: [CityData]
    var links: [Link]
    var metadata: [String: Int]
}

struct CityData: Codable {
    var id: Int
    var type: String
    var name: String
    var city: String
    var region: String
}

struct Link: Codable {
    var rel: String
    var href: String
}

struct MetaData: Codable {
    var offSet: Int
    var count: Int
}
