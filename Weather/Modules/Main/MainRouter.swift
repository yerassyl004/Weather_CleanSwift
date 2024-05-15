//
//  MainRouter.swift
//  Weather
//
//  Created by Ерасыл Еркин on 08.04.2024.
//

import UIKit

@objc protocol MainRoutingLogic {
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

final class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
}
