//
//  Weather.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 30.1.2021.
//

import Foundation

struct Weather: Codable, Hashable {
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.name == rhs.name
    }
    
    var coord: [String:Double]
    var weather: [WeatherType]
    var main: MainInfo
    var visibility: Int
    var wind: [String:Double]
    var sys: System
    var name: String
}

struct WeatherType: Codable, Hashable {
    var main: String
    var description: String
    var icon: String
}

struct MainInfo: Codable, Hashable {
    var temp: Double
    var temp_min: Double
    var temp_max: Double
    var feels_like: Double
    var pressure: Double
    var humidity: Double
}

struct System: Codable, Hashable {
    var country: String
    var sunrise: Int
    var sunset: Int
}
