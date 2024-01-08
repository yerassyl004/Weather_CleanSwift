//
//  WeatherWidgetBundle.swift
//  WeatherWidget
//
//  Created by Ерасыл Еркин on 12.01.2024.
//

import WidgetKit
import SwiftUI

@main
struct WeatherWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherWidget()
        WeatherWidgetLiveActivity()
    }
}
