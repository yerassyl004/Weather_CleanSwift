//
//  MainPresenter.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.04.2024.
//

import Foundation

protocol MainPresentationLogic {
    func presentHourly(forecast: WelcomeHourly)
    func presentWeekly(forecast: WelcomeWeekly)
}

class MainPresenter {
    weak var viewController: MainDisplayLogic?
}

extension MainPresenter: MainPresentationLogic {
    func presentHourly(forecast: WelcomeHourly) {
        viewController?.displayHourly(forecast: forecast)
    }
    
    func presentWeekly(forecast: WelcomeWeekly) {
        viewController?.displayWeekly(forecast: forecast)
    }
    
}
