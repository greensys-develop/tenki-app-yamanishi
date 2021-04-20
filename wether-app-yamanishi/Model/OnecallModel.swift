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
    let timezone_offset: Int
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
    let feels_like: Double?
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double?
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
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
    let feels_like: Double?
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double?
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double?
    let weather: [Weather]?
}

struct Daily: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moon_phase: Double
    let temp: Temp
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double?
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
    let feels_like: [FeelsLike]?
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
