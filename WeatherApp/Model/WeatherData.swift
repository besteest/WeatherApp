//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Beste on 17.12.2023.
//

import Foundation

//typealias -> 2 protokolun birlesimi -> encoadable & decodable
struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
    
}

struct Main : Codable {
    let temp : Double
}

struct Weather: Codable {
    let id: Int
}
