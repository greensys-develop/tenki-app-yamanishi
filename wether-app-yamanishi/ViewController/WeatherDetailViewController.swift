//
//  WeatherDetailViewController.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/13.
//

import UIKit
import PKHUD

class WeatherDetailViewController: UIViewController {
    
    // 都道府県
    var selectedItem: (name: String, queryName: String)?
    
    // 週間天気
    var dailySelectedItem: Daily?
    
    let f = DateFormatter()
    var coordinate: Coordinate = (lat: 0.0, lon: 0.0)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var rainyPercentLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        setupDate()
        setupDatailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 条件分岐でそれぞれの画面を表示
    func setupDatailView() {
        if let item = selectedItem {
            //都道府県情報を表示
            let params: [String: Any] = ["q": item.queryName, "lang": "ja", "APPID": ApiClient.appId]
            let prefectureWeather = PrefectureWeatherRequest(params: params)
            prefectureWeather.request { [weak self] (response) in
                self?.weatherModelSetupView(response: response)
            }
        } else if let daily = dailySelectedItem {
            // 現在地の週間天気を表示
            onecallSetupView(daily: daily)
        } else {
            //現在地情報を表示
            let params: [String: Any] = ["lat": coordinate.lat, "lon": coordinate.lon, "lang": "ja", "APPID": ApiClient.appId]
            let currentLocationWeather = CurrentLocationWeatherRequest(params: params)
            currentLocationWeather.request { [weak self] (response) in
                self?.weatherModelSetupView(response: response)
            }
        }
    }
    
    // Dateセットアップ
    func setupDate() {
        f.timeStyle = .none
        f.dateStyle = .short
        f.locale = Locale(identifier: "ja_JP")
    }
    
    // Viewの初期化
    func setupView() {
        nameLabel.text = ""
        dateLabel.text = ""
        maxTemperatureLabel.text = ""
        minTemperatureLabel.text = ""
        humidityLabel.text = ""
        weatherLabel.text = ""
        cloudsLabel.text = ""
        uvIndexLabel.text = ""
        rainyPercentLabel.text = ""
        
        cloudsLabel.isHidden = true
        uvIndexLabel.isHidden = true
        rainyPercentLabel.isHidden = true
    }
    
    @IBAction func tapOnCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func weatherModelSetupView(response: WeatherModel?) {
        guard let weather = response else {
            HUD.flash(.labeledError(title: "通信が正常動作できませんでした。", subtitle: nil))
            dismiss(animated: true, completion: nil)
            return
        }
        
        nameLabel.text = weather.name
        dateLabel.text = f.string(from: Date())
        maxTemperatureLabel.text = "最高気温：" + String(round(weather.main.tempMax - 273.15)) + "℃"
        minTemperatureLabel.text = "最低気温：" + String(round(weather.main.tempMin - 273.15)) + "℃"
        humidityLabel.text = "湿度：" + String(weather.main.humidity) + "%"
        
        if let weatherValue = weather.weather.first {
            weatherLabel.text = "天気：" + (weatherValue.description)
            weatherImage.setImageByDefault(with: weatherValue.icon)
        }
    }
    
    private func onecallSetupView(daily: Daily) {
        cloudsLabel.isHidden = false
        uvIndexLabel.isHidden = false
        rainyPercentLabel.isHidden = false
        nameLabel.text = LocationManager.shared.placeName
        dateLabel.text = Util.unixToString(date: TimeInterval(daily.dt))
        maxTemperatureLabel.text = "最高気温：" + String(round(daily.temp.max - 273.15)) + "℃"
        minTemperatureLabel.text = "最低気温：" + String(round(daily.temp.min - 273.15)) + "℃"
        humidityLabel.text = "湿度：" + String(daily.humidity) + "%"
        cloudsLabel.text = "曇り：" + String(daily.clouds) + "%"
        uvIndexLabel.text = "UVインデックス値：" + String(Int(round((daily.uvi))))
        rainyPercentLabel.text = "降水確率：" + String(Int(round((daily.pop * 100)))) + "%"
        
        if let weatherValue = daily.weather?.first {
            weatherLabel.text = "天気：" + weatherValue.description
            weatherImage.setImageByDefault(with: weatherValue.icon)
        }
    }
    
}
