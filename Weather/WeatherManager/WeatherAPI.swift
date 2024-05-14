//
//  WeatherAPI.swift
//  Weather
//
//  Created by Ерасыл Еркин on 14.05.2024.
//

import Moya
import Foundation

enum WeatherAPI {
    case fetchHourlyForecast(cityName: String)
    case fetchWeeklyForecast(cityName: String)
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.weatherbit.io/v2.0")!
    }
    
    var path: String {
        switch self {
        case .fetchHourlyForecast:
            return "/forecast/hourly"
        case .fetchWeeklyForecast:
            return "/forecast/daily"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data() // You can provide sample data for testing if needed
    }
    
    var task: Task {
        switch self {
        case .fetchHourlyForecast(let cityName), .fetchWeeklyForecast(let cityName):
            return .requestParameters(parameters: ["city": cityName, "key": "ff7d9445d443415f8ee31181df1ee3ff"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
