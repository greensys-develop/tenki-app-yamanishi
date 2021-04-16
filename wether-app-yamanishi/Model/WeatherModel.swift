//
//  WeatherModel.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/15.
//

import Foundation

struct WeatherModel: Codable {
    let cod: Int
    let id: Int
    let name: String
    let timezone :Int
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int?
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max :Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int?
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Double?
    let sunset: Double?
}

