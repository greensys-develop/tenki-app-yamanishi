//
//  OneCallModel.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/16.
//

import Foundation

struct OneCallModel: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current?
    let minutely: [Minutely]?
    let hourly: [Hourly]?
    let daily: [Daily]?
}

struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelLike: Double?
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double?
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]?
    let hourly: [Hourly]?
    let daily: [Daily]?
}

struct Minutely: Codable {
    let dt: Int
    let precipitation: Int
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let feelsLike: Double?
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double?
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [Weather]?
}

struct Daily: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonPhase: Double
    let temp: Temp
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [Weather]?
    let clouds: Int
    let pop: Double?
    let rain: Double?
    let uvi: Double?
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
    let feelsLike: [FeelsLike]?
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
