//
//  CityData.swift
//  Weather
//
//  Created by Ерасыл Еркин on 10.01.2024.
//

import Foundation

struct CityData: Codable {
    let name: String
    let temperature: Int
    let icon: String
    let currentCity: Bool
}

var cities: [CityData] = []

struct AddCity {
    static var addCity: [CityData] = {
        [
            .init(name: "Chicago", temperature: 10, icon: "c01n", currentCity: true),
            .init(name: "London", temperature: 10, icon: "c01d", currentCity: false)
        ]
    }()
    
    static func cityData() -> [CityData] {
        return addCity
    }
    
}

