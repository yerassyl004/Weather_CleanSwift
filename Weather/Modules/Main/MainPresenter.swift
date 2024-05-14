//
//  MainPresenter.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.04.2024.
//

import Foundation
import UIKit

protocol MainPresentationLogic {
    func presentHourly(forecast: WelcomeHourly)
    func presentWeekly(forecast: WelcomeWeekly)
}

final class MainPresenter {
    weak var viewController: MainDisplayLogic?
}

extension MainPresenter: MainPresentationLogic {
    
    func presentWeekly(forecast: WelcomeWeekly) {
        var weeklyForecast = [MainModel.DaylyModel]()
        
        for model in forecast.data {
            var nightImage = model.weather.icon
            if !nightImage.isEmpty {
                nightImage.removeLast()
                nightImage.append("n")
            }
            
            let day = model.datetime
            let humidity = model.rh
            let weatherImage = UIImage(named: model.weather.icon)
            let weatherNightImage = UIImage(named: nightImage)
            let minTemp = Int(round(model.minTemp))
            let maxTemp = Int(round(model.maxTemp))
            
            let cellModel = MainModel.DaylyModel(day: day,
                                                 humidity: humidity,
                                                 weatherImage: weatherImage,
                                                 weatherNightImage: weatherNightImage,
                                                 minTem: minTemp,
                                                 maxTem: maxTemp)
            
            weeklyForecast.append(cellModel)
        }
        let weeklyData = Array(weeklyForecast.prefix(10))
        viewController?.displayWeeklyData(data: weeklyData)
    }
    
    func presentHourly(forecast: WelcomeHourly) {
        var hourlyForecast = [MainModel.HourlyModel]()
        var currentForecast: MainModel.CurrentWeather?
        
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = "HH:mm"
        
        for datum in forecast.data {
            if let date = dateFormatterInput.date(from: datum.timestampLocal) {
                let hour = dateFormatterOutput.string(from: date)
                let image = UIImage(named: "\(datum.weather.icon)")
                let temp = "\(Int(round(datum.temp)))°"
                let humidity = "\(datum.rh)%"
                let model = MainModel.HourlyModel(hour: hour,
                                                  image: image,
                                                  humidity: humidity,
                                                  temp: temp)
                hourlyForecast.append(model)
            } else {
                print("Invalid date string format")
            }
        }
        
        if let data = forecast.data.first {
            let temp = "\(Int(round(data.temp)))°"
            let appTemp = "Feels Like \(Int(round(data.appTemp)))°"
            let description = data.weather.description
            
            currentForecast = MainModel.CurrentWeather(temp: temp,
                                                       cityName: forecast.cityName,
                                                       appTemp: appTemp,
                                                       description: description)
        }
        
        let first23HourlyForecast = Array(hourlyForecast.prefix(23))
        
        if let currentForecast = currentForecast {
            viewController?.displayHourlyForecast(forecast: first23HourlyForecast,
                                                  currentForecast: currentForecast)
        }
    }
    
}
