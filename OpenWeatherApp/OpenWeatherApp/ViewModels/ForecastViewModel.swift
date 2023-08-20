//  ForecastViewModel.swift
//  OpenWeatherApp
//  Created by Sara on 18/08/2023.
import Foundation
import SwiftUI

class ForecastViewModel: ObservableObject {
    
 @Published var forecastResponse = Forecast(
        main: Main(
            temp: 0.0,
            pressure:0,
            humidity: 0),
        wind: Wind(
            speed: 0.0),
        weather: [Weather(
            main: "",
            description: "",
            icon: "")],
        sys: Sys(
            sunrise: 0,
            sunset: 0,
            country: ""),
        name: ""
     )
 @Published  var cityName = "Riyadh"
 @Published  var showAlert : Bool = false
 @Published  var errorMessage: String = ""
 @Published  var citiesNames = """
    Yanbu
    Umluj
    Turaif
    Tayma
    Taif
    Tabuk
    Shaybah
    Safwa
    Sakakah
    Saihat
    Riyadh
    Rafha
    Rabigh
    Qurayyat
    Qaisumah
    Najran
    Medina
    Mecca
    Khaybar
    Khobar
    Jubail
    Jizan
    Jeddah
    Jalajil
    Hofuf
    Haql
    Ha'il
    Ghawiyah
    Farasan
    Diriyah
    Duba
    Dhurma
    Dhahran
    Dammam
    Buraydah
    Bisha
    Badr
    AlUla
    Abha
    """.components(separatedBy: "\n")
    
 func convertTempUnit(_ UnitSelection: Int){
     var unit : Units
     switch UnitSelection {
     case 0 :
         unit = .metric
     case 1 :
         unit = .imperial
     default:
         unit = .metric
     }
     switch unit {
     case .imperial:
         forecastResponse.main.temp = (forecastResponse.main.temp*9/5) + 32
     case .metric:
         forecastResponse.main.temp = (forecastResponse.main.temp-32)*5/9
     }
 }
    
 func convertSpeedUnit(_ UnitSelection: Int){
        var unit : Units
        switch UnitSelection {
        case 0 :
            unit = .metric
        case 1 :
            unit = .imperial
        default:
            unit = .metric
        }
        switch unit {
        case .imperial:
            forecastResponse.wind.speed = forecastResponse.wind.speed * 2.237
        case .metric:
            forecastResponse.wind.speed = forecastResponse.wind.speed / 2.237
         
        }
 }
    
 func convertTime(_ unixTime : Int)-> String{
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: date)   
    }
    
 func callAPI(){

        let session : URLSession = .shared
        guard let url = URL( string :"https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=380236dfd66af54885e21de3ccb68e69&units=metric") else{
          return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request){ (data, response, error) in
             if let error = error {
                 self.errorMessage = "Error: Something went wrong :("
                 self.showAlert = true
                 return
             }
             if let data = data {
                 if let content = String(bytes: data, encoding: .utf8){
                     do {
                         let response = try JSONDecoder().decode(Forecast.self, from: data)
                         self.forecastResponse = response
                     } catch {
                         self.errorMessage = "Error: City not found"
                         self.showAlert = true
                     }
                 }
             }
        }
         task.resume()
 }  

    
    
}
   

