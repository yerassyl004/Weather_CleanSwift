////
////  ViewPresenter.swift
////  Weather
////
////  Created by Ерасыл Еркин on 26.03.2024.
////
//
//import Foundation
//
//final class MainViewModel {
//    
//    private var weeklyForecast: [DatumWeekly]
//    
//    init(weeklyForecast: [DatumWeekly]) {
//        self.weeklyForecast = weeklyForecast
//    }
//    
//    func dataOfWeek() -> [DatumWeekly] {
//        let firstSevenArticles: [DatumWeekly] = Array(weeklyForecast.prefix(10))
//        var transformedData: [DatumWeekly] = []
//        
//        for article in firstSevenArticles {
//            let transformedArticle = transformArticle(article)
//            transformedData.append(transformedArticle)
//        }
//        
//        return transformedData
//    }
//    
//    
//    
//    private func transformArticle(_ article: DatumWeekly) -> DatumWeekly {
//            return DatumWeekly(
//                appMaxTemp: article.appMaxTemp,
//                appMinTemp: article.appMinTemp,
//                clouds: article.clouds,
//                cloudsHi: article.cloudsHi,
//                cloudsLow: article.cloudsLow,
//                cloudsMid: article.cloudsMid,
//                datetime: article.datetime,
//                dewpt: article.dewpt,
//                highTemp: article.highTemp,
//                lowTemp: article.lowTemp,
//                maxTemp: article.maxTemp,
//                minTemp: article.minTemp,
//                moonPhase: article.moonPhase,
//                moonPhaseLunation: article.moonPhaseLunation,
//                moonriseTs: article.moonriseTs,
//                moonsetTs: article.moonsetTs,
//                ozone: article.ozone,
//                pop: article.pop,
//                precip: article.precip,
//                pres: article.pres,
//                rh: article.rh,
//                slp: article.slp,
//                snow: article.snow,
//                snowDepth: article.snowDepth,
//                sunriseTs: article.sunriseTs,
//                sunsetTs: article.sunsetTs,
//                temp: article.temp,
//                ts: article.ts,
//                uv: article.uv,
//                validDate: article.validDate,
//                vis: article.vis,
//                weather: article.weather,
//                windCdir: article.windCdir,
//                windCdirFull: article.windCdirFull,
//                windDir: article.windDir,
//                windGustSpd: article.windGustSpd,
//                windSpd: article.windSpd
//            )
//        }
//    
//}
