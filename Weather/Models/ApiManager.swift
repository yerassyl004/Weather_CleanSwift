//
//  ApiManager.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.01.2024.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    
    private init() {}
    
    private let apiKey = "c83f5fe73b4b4ef683870d2f0508e6d9"
    private let baseURL = "https://api.weatherbit.io/v2.0/forecast/hourly"
    
    func fetchHourlyForecast(cityName: String, completion: @escaping (Result<WelcomeHourly, Error>) -> Void) {
        let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?city=\(encodedCityName)&key=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let noDataError = NSError(domain: "ApiManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    completion(.failure(noDataError))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let forecastData = try decoder.decode(WelcomeHourly.self, from: data)
                    completion(.success(forecastData))
                } catch {
                    completion(.failure(error))
                }
            }
            
            dataTask.resume()
        }
    }
    
    
    func fetchWeeklyForecastData(for cityName: String, completion: @escaping (Result<WelcomeWeekly, Error>) -> Void) {
        let apiKey = "c83f5fe73b4b4ef683870d2f0508e6d9"
        let urlString = "https://api.weatherbit.io/v2.0/forecast/daily?city=\(cityName)&key=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let dataError = NSError(domain: "com.example.WeatherApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    completion(.failure(dataError))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let weeklyForecastData = try decoder.decode(WelcomeWeekly.self, from: data)
                    completion(.success(weeklyForecastData))
                } catch {
                    completion(.failure(error))
                }
            }
            
            dataTask.resume()
        }
    }
    
    func fetchCurrentWeather(for cityName: String, completion: @escaping (WelcomeDayly?) -> Void) {
        
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    // Add more error cases as needed
}
