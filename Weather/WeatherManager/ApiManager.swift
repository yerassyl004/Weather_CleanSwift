//
//  ApiManager.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.01.2024.
//

import Foundation
import Moya

final class ApiManager {
    
    static let shared = ApiManager()
    private let provider = MoyaProvider<WeatherAPI>()
    
    private init() {}
    
    func fetchHourlyForecast(cityName: String, 
                             completion: @escaping (Result<WelcomeHourly, Error>) -> Void) {
        provider.request(.fetchHourlyForecast(cityName: cityName)) { result in
            switch result {
            case .success(let response):
                do {
                    let forecastData = try response.map(WelcomeHourly.self)
                    completion(.success(forecastData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchWeeklyForecastData(for cityName: String, completion: @escaping (Result<WelcomeWeekly, Error>) -> Void) {
        provider.request(.fetchWeeklyForecast(cityName: cityName)) { result in
            switch result {
            case .success(let response):
                do {
                    let forecastData = try response.map(WelcomeWeekly.self)
                    completion(.success(forecastData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
