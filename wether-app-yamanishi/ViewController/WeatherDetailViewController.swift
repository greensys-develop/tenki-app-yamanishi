//
//  WeatherDetailViewController.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/13.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    var selectedItem: (name: String, queryName: String)!
    var weeklySelectedItem: (dt: Int, dateStr: String)?
    var image: UIImage!
    let f = DateFormatter()
    let now = Date()
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatailView()
    }
    
    // 条件分岐でそれぞれの画面を表示
    func setupDatailView() {
        if let item = selectedItem {
            //都道府県情報を表示
            let params: [String: Any] = ["q": item.queryName, "lang": "ja", "APPID": ApiClient.appId]
            let prefectureWeather = PrefectureWeatherRequest(params: params)
            prefectureWeather.request { (response) in
                self.weatherModelSetupView(response: response)
            }
        } else if weeklySelectedItem != nil {
            self.dateLabel.text = weeklySelectedItem?.dateStr
            // 週間予報を表示
            let params: [String: Any] = ["lat": coordinate.lat, "lon": coordinate.lon, "lang": "ja", "APPID": ApiClient.appId]
            let weeklyWeather = WeeklyWeatherRequest(params: params)
            weeklyWeather.request { (response) in
                self.nameLabel.text = response.timezone
                self.onecallSetupView(response: response.daily?.filter { $0.dt == self.weeklySelectedItem?.dt })
            }
        } else {
            //現在地情報を表示
            let params: [String: Any] = ["lat": coordinate.lat, "lon": coordinate.lon, "lang": "ja", "APPID": ApiClient.appId]
            let currentLocationWeather = CurrentLocationWeatherRequest(params: params)
            currentLocationWeather.request { (response) in
                self.weatherModelSetupView(response: response)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func weatherModelSetupView(response: WeatherModel?) {
        self.nameLabel.text = response?.name
        self.dateLabel.text = self.f.string(from: now)
        self.maxTemperatureLabel.text = "最高気温：" + String(round((response?.main.tempMax)! - 273.15)) + "℃"
        self.minTemperatureLabel.text = "最低気温：" + String(round((response?.main.tempMin)! - 273.15)) + "℃"
        self.humidityLabel.text = "湿度：" + String((response?.main.humidity)!) + "%"
        self.weatherLabel.text = "天気：" + (response?.weather.first!.description)!

        self.weatherImage.setImageByDefault(with: (response?.weather.first!.icon)!)
    }
    
    private func onecallSetupView(response: [Daily]?) {
        self.cloudsLabel.isHidden = false
        self.uvIndexLabel.isHidden = false
        self.rainyPercentLabel.isHidden = false
        self.nameLabel.text = LocationManager.shared.placeName
        self.dateLabel.text = weeklySelectedItem?.dateStr
        self.maxTemperatureLabel.text = "最高気温：" + String(round((response?.first?.temp.max)! - 273.15)) + "℃"
        self.minTemperatureLabel.text = "最低気温：" + String(round((response?.first?.temp.min)! - 273.15)) + "℃"
        self.humidityLabel.text = "湿度：" + String((response?.first?.humidity)!) + "%"
        self.cloudsLabel.text = "曇り：" + String(((response?.first!.clouds)!)) + "%"
        self.uvIndexLabel.text = "UVインデックス値：" + String(Int(round((response?.first?.uvi)!)))
        self.rainyPercentLabel.text = "降水確率：" + String(Int(round((response?.first?.pop)! * 100))) + "%"
        self.weatherLabel.text = "天気：" + (response?.first?.weather?.first?.description)!
        self.weatherImage.setImageByDefault(with: (response?.first?.weather?.first!.icon)!)
    }
    
}
