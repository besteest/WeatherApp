//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Beste on 17.12.2023.
//

import Foundation

import CoreLocation

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
}

struct WeatherManager {
    
    //api url
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=7a3e78cc7320d2a84833573b69621135&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        
        //yer ismine göre çağırmış olduk
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        //1. create a URL
        if let url = URL(string: urlString) {
            
            //2. create a URLSession
            let session = URLSession(configuration: .default)
            //3. give the session a task
            //closure
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    //fonksiyondan çık devam etme
                    return
                }
                
                if let safeData = data {
                    /*let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString)*/
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        do {
            //WeatherData.self -> çekilen veriler WeatherData içerisindeki verilere eşitleniyor.
            //Bu yüzden adları json dosyasındaki ile birebir aynı olmalı
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}

