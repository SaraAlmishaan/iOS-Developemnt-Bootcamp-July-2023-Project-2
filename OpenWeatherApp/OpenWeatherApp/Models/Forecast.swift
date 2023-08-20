//  Forecast.swift
//  OpenWeatherApp
//  Created by Sara on 18/08/2023.
import Foundation

struct Forecast: Codable {
  var main: Main
  var wind : Wind
  var weather : [Weather]
  var sys: Sys
  var name : String
}
