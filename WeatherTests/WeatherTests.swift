//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Ерасыл Еркин on 23.04.2024.
//

import XCTest
@testable import Weather

final class WeatherTests: XCTestCase {
    
    let expectation = XCTestExpectation(description: "Fetch forecast data")
    
    func testWeeklyFetchedData() {
        
        ApiManager.shared.fetchWeeklyForecastData(for: "Almaty") { result in
            switch result {
            case .success(let weeklyForecastData):
                XCTAssertNotNil(weeklyForecastData)
            case .failure(let error):
                XCTFail("Error fetching data: \(error)")
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testSpecialCharacterCityName() {
        ApiManager.shared.fetchWeeklyForecastData(for: "Rio De Janeiro") { result in
            switch result {
            case .success(let weeklyForecastData):
                let cityName = weeklyForecastData.cityName
                XCTAssertEqual(cityName, "Rio-de-janeiro")
                XCTAssertNotNil(weeklyForecastData)
                
            case .failure(let error):
                XCTFail("Fetching data for city with special characters failed: \(error)")
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testWeeklyEmptyInputData() {
        ApiManager.shared.fetchWeeklyForecastData(for: "") { result in
            switch result {
            case .success(let weeklyForecastData):
                XCTAssertNil(weeklyForecastData)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testHourlyFetchedData() {
        ApiManager.shared.fetchHourlyForecast(cityName: "Almaty") { result in
            switch result {
            case .success(let hourlyForecast):
                XCTAssertNotNil(hourlyForecast)
            case .failure(let error):
                XCTFail("Error fetching data: \(error)")
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testHourlyForEmptyInput() {
        ApiManager.shared.fetchHourlyForecast(cityName: "") { result in
            switch result {
            case .success(let hourlyForecast):
                XCTAssertNil(hourlyForecast)
            case .failure(let error):
                print("Error fetching hourly forecast: \(error)")
                XCTAssertNotNil(error)
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
