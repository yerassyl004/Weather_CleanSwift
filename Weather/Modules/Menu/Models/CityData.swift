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
    var currentCity: Bool? = false
}
