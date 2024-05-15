//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Ерасыл Еркин on 15.05.2024.
//

import UIKit

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Save Cities
    func saveCurrentCity(cityName: String) {
        defaults.setValue(cityName, forKey: AppKeys.currentCityKey)
        defaults.synchronize()
    }
    
    func getCurrentCity() -> String? {
        let city = defaults.string(forKey: AppKeys.currentCityKey)
        return city
    }
    
    func saveCityData(data: [CityData]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.set(encoded, forKey: AppKeys.citiesKey)
        }
    }
    
    func getCityData() -> [CityData]? {
        if let data = UserDefaults.standard.data(forKey: AppKeys.citiesKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([CityData].self, from: data) {
                return decoded
            }
        }
        return nil
    }
}
