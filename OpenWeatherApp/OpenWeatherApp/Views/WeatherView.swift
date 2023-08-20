//  WeatherView.swift
//  OpenWeatherApp
//  Created by Sara on 17/08/2023.
import SwiftUI

struct WeatherView: View {
    @ObservedObject var objForecastViewModel = ForecastViewModel()
    @State var unitTemp = 0
    @State var unitSpeed = 0
    @State var unitTempDefinition = "°C"
    @State var unitSpeedDefinition = "m/s"
    @State var selectedCityName = "Riyadh"
    @State var searchedText : String = ""
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(
            colors: [Color("myBlack").opacity(0.9),
                     Color("myBlack").opacity(0.7)
                    ]),
        startPoint:.leading, endPoint: .topTrailing)
  
    var body: some View {
        ZStack{
               backgroundGradient
                    .ignoresSafeArea()
             VStack {
                    HStack {
                            Image(systemName: "magnifyingglass")
                                .scaleEffect(1.4)
                                .frame(width : 33  , alignment : .center)
                            TextField( "Search", text: $searchedText)
                                .foregroundColor(Color.white.opacity(0.9))
                                .frame(height: 35)
                        }
                         .padding(.vertical, 1)
                         .padding(.horizontal, 2)
                         .background(Color.gray.opacity(0.2))
                         .cornerRadius(11)
                         .foregroundColor(.gray)
                         .frame(width : 365  , alignment : .leading)
                    HStack{
                           Image(systemName: "location.fill")
                               .scaleEffect(1.1)
                           Text(" \(objForecastViewModel.forecastResponse.name) ,   \(objForecastViewModel.forecastResponse.sys.country) ")
                               .font(.title2)
                               .bold()
                               .frame(width: 190,alignment: .leading)
                               .foregroundColor(Color.white.opacity(0.8))
                           Spacer()
                           Picker("city", selection: $selectedCityName ) {
                               ForEach(objForecastViewModel.citiesNames , id: \.self) {  item in
                                  Text("\(item)").tag("\(item)")
                                 }
                              }.pickerStyle(.menu)
                              .accentColor(.white)
                              .border(Color.gray)
                         }
                 ScrollView{
                       ZStack{
                          AsyncImage(
                              url: URL(string:"https://openweathermap.org/img/wn/\(objForecastViewModel   .forecastResponse.weather[0].icon)@2x.png"),
                              content: { image in
                               image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: 260, alignment: .top)
                              },
                              placeholder: {
                                 ProgressView()
                              }
                          )
                          VStack{
                              Text("\(objForecastViewModel.forecastResponse.weather  [0].main)")
                                  .font(.largeTitle)
                                  .foregroundColor(Color.white.opacity(0.8))
                                  .fontDesign(.monospaced)
                              Text("\(objForecastViewModel.forecastResponse.weather  [0].description)")
                                  .font(.title)
                          }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                       }
                
                     Text("\(objForecastViewModel.forecastResponse.main.temp, specifier: "%.2f") \(unitTempDefinition)")
                         .font(.system(size: 45))
                         .foregroundColor(Color.white.opacity(0.9))
                         .frame(maxWidth: .infinity,alignment: .trailing)
                     HStack{
                         Image(systemName: "wind")
                             .scaleEffect(1.5)
                             .padding()
                         Text("\(objForecastViewModel.forecastResponse.wind.speed, specifier: "%.2f") \(unitSpeedDefinition)")
                             .font(.title)
                             .frame(width: 300,alignment: .leading)
                     }
                     HStack{
                         Image(systemName: "drop.fill")
                             .scaleEffect(1.5)
                             .padding()
                         Text("\(objForecastViewModel.forecastResponse.main.humidity) %")
                             .font(.title)
                             .frame(width: 300,alignment: .leading)
                     }
                     HStack{
                         Image(systemName: "speedometer")
                             .scaleEffect(1.5)
                             .padding()
                         Text("\(objForecastViewModel.forecastResponse.main.pressure) hPa")
                             .font(.title)
                             .frame(width: 300,alignment: .leading)
                     }
                     HStack{
                         Image(systemName: "sunrise.fill")
                             .scaleEffect(1.5)
                             .padding()
                         Text("\(objForecastViewModel.convertTime(objForecastViewModel.forecastResponse.sys.sunrise)) ")
                             .font(.title)
                             .frame(width: 300,alignment: .leading)
                     }
                     HStack{
                         Image(systemName: "sunset.fill")
                             .scaleEffect(1.5)
                             .padding()
                         Text("\(objForecastViewModel.convertTime(objForecastViewModel.forecastResponse.sys.sunset)) ")
                             .font(.title)
                             .frame(width: 300,alignment: .leading)
                     }
                     Text("_________________________________________")
                     HStack{
                         Text("Temperature")
                            .foregroundColor(Color.white.opacity(0.7))
                            .font(.title2)
                         Spacer()
                         Picker("Units", selection: $unitTemp ) {
                             Text("Metric").tag(0)
                             Text("Imperial").tag(1)
                         }.pickerStyle(.segmented)
                          .background(Color.gray.opacity(0.5))
                          .cornerRadius(8)
                          .frame(width: 210,alignment: .leading)
                     }
                     HStack{
                         Text("Wind Speed")
                             .foregroundColor(Color.white.opacity(0.7))
                             .font(.title2)
                         Spacer()
                         Picker("Units", selection: $unitSpeed ) {
                             Text("Metric").tag(0)
                             Text("Imperial").tag(1)
                         }.pickerStyle(.segmented)
                          .background(Color.gray.opacity(0.5))
                          .cornerRadius(8)
                          .frame(width: 210,alignment: .leading)
                     }
                  }//Scroll
             }//VStack
              .padding()
              .foregroundColor(Color.white.opacity(0.5))
      }//ZStack
        .onAppear{
            objForecastViewModel.callAPI()
           }
        .onChange(of: searchedText){ value in
            searchCity(value)
           }
        .onChange(of: selectedCityName){ value in
            searchCity(value)
           }
        .onChange(of: unitTemp){ value in
            unitTempSelection(value)
        }
        .onChange(of: unitSpeed){ value in
            unitSpeedSelection(value)
           }
        .alert(isPresented : $objForecastViewModel.showAlert){
            Alert(title : Text(objForecastViewModel.errorMessage))
        }
    }//body
    func searchCity(_ value : String){
        objForecastViewModel.cityName = value
        objForecastViewModel.callAPI()
        }
    func unitTempSelection(_ value : Int){
        objForecastViewModel.convertTempUnit(value)
        switch value{
        case 0:
            unitTempDefinition = "°C"
        case 1:
            unitTempDefinition = "°F"
        default:
            unitTempDefinition = "°C"
        }
    }
    func unitSpeedSelection(_ value : Int){
        objForecastViewModel.convertSpeedUnit(value)
        switch value{
        case 0:
            unitSpeedDefinition = "m/s"
        case 1:
            unitSpeedDefinition = "mph"
        default:
            unitSpeedDefinition = "m/s"
        }
   }
}//end

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}




