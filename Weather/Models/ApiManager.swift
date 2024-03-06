//
//  ApiManager.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.01.2024.
//

import Foundation
import Alamofire

class ApiManager {
    
    static let shared = ApiManager()
    
    private init() {}
    
    private let apiKey = "767697f89fc6497ba92b089b1904da3f"
    
    func fetchHourlyForecast(cityName: String, completion: @escaping (Result<WelcomeHourly, Error>) -> Void) {
        let baseURL = "https://api.weatherbit.io/v2.0/forecast/hourly"
        
        let parameters: [String: Any] = [
            "city": cityName,
            "key": apiKey
        ]
        
        AF.request(baseURL, parameters: parameters).responseDecodable(of: WelcomeHourly.self) { response in
            switch response.result {
            case .success(let forecastData):
                completion(.success(forecastData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchWeeklyForecastData(for cityName: String, completion: @escaping (Result<WelcomeWeekly, Error>) -> Void) {
        let baseURL = "https://api.weatherbit.io/v2.0/forecast/daily"
        
        let parameters: [String: Any] = [
            "city": cityName,
            "key": apiKey
        ]
        
        AF.request(baseURL, parameters: parameters).responseDecodable(of: WelcomeWeekly.self) { response in
            switch response.result {
            case .success(let forecastDate):
                completion(.success(forecastDate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
