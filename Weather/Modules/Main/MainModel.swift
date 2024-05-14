//
//  MainModel.swift
//  Weather
//
//  Created by Ерасыл Еркин on 14.05.2024.
//

import UIKit

class MainModel {
    struct DaylyModel {
        let day: String
        let humidity: Int
        let weatherImage: UIImage?
        let weatherNightImage: UIImage?
        let minTem: Int
        let maxTem: Int
    }
    
    struct CurrentWeather {
        let temp: String
        let cityName: String
        let appTemp: String
        let description: String
    }
    
    struct HourlyModel {
        let hour: String
        let image: UIImage?
        let humidity: String
        let temp: String
    }
}
