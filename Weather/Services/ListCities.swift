//
//  ListCities.swift
//  Weather
//
//  Created by Yerassyl Yerkin on 11.08.2024.
//

import Foundation

class ListCities {
    
    private var defaults = UserDefaultsManager.shared
    static let shared = ListCities()
    
    public func getListCities() -> [CityData] {
        if let cityData = defaults.getCityData() {
            return cityData
        }
        return []
    }
}
