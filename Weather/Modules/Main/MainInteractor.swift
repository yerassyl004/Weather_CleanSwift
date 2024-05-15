//
//  MainInteractor.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.04.2024.
//

import Foundation

protocol MainBusinessLogic {
    func fetchDataForCity(for cityName: String)
    func fetchDataForWeek(for cityName: String)
}

protocol MainDataStore {
    
}

class MainInteractor: MainDataStore {
    var presenter: MainPresentationLogic?
}

extension MainInteractor: MainBusinessLogic {
    
    func fetchDataForWeek(for cityName: String) {
        ApiManager.shared.fetchWeeklyForecastData(for: cityName) { result in
            switch result {
            case .success(let weeklyForecastData):
                self.presenter?.presentWeekly(forecast: weeklyForecastData)
                print("Success")
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func fetchDataForCity(for cityName: String) {
        ApiManager.shared.fetchHourlyForecast(cityName: cityName) { result in
            switch result {
            case .success(let hourlyForecast):
                self.presenter?.presentHourly(forecast: hourlyForecast)
                
            case .failure(let error):
                print("Error fetching hourly forecast: \(error)")
            }
        }
    }
    
}
