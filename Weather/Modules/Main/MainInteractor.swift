//
//  MainInteractor.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.04.2024.
//

import Foundation
import Combine

protocol MainBusinessLogic {
    func fetchDataForCity(for cityName: String)
    func fetchDataForWeek(for cityName: String)
    func fetchDataWithCordinate()
}

protocol MainDataStore {
    
}

class MainInteractor: MainDataStore, MainBusinessLogic {
    var presenter: MainPresentationLogic?
    private var cancellables = Set<AnyCancellable>()
    private var locationManager: CurrentLocation?
    
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
    
    func fetchDataWithCordinate() {
        locationManager = CurrentLocation()
        let defaults = UserDefaultsManager.shared
        var cities = defaults.getCityData()
        var cityData = [CityData]()
        if let cities {
            cityData.append(contentsOf: cities)
        }
        
        print("fetchDataWithCordinate called")
        
        locationManager?.requestCurrentLocation()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to get location: \(error.localizedDescription)")
                case .finished:
                    print("Finished receiving location")
                }
            }, receiveValue: { coordinate in
                ApiManager.shared.fetchHourlyForecasCordinate(
                    lat: coordinate.latitude,
                    long: coordinate.longitude) { result in
                        switch result {
                        case .success(let hourlyForecast):
                            if let data = hourlyForecast.data.first {
                                if cityData.contains(where: { $0.name.lowercased() == hourlyForecast.cityName.lowercased() }) {
                                    print("City \(hourlyForecast.cityName) is already in the list.")
                                    return
                                } else {
                                    cityData.append(CityData(name: hourlyForecast.cityName, temperature: Int(round(data.temp)), icon: data.weather.icon, currentCity: true))
                                    defaults.saveCityData(data: cityData)
                                }
                            }
                            self.presenter?.presentHourly(forecast: hourlyForecast)
                            
                        case .failure(let error):
                            print("Error fetching hourly forecast: \(error)")
                        }
                    }
                ApiManager.shared.fetchWeeklyForecasCordinate(
                    lat: coordinate.latitude,
                    long: coordinate.longitude) { result in
                        switch result {
                        case .success(let hourlyForecast):
                            self.presenter?.presentWeekly(forecast: hourlyForecast)
                        case .failure(let error):
                            print("Error fetching hourly forecast: \(error)")
                        }
                    }
            })
            .store(in: &cancellables)
    }
}
