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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = selectedItem {
            ApiClient.getPrefectureWeather(byCity: item.queryName) { response, errorString in
                self.weatherModelSetupView(response: response)
            }
        } else if weeklySelectedItem != nil {
            self.dateLabel.text = weeklySelectedItem?.dateStr
            
            // TableViewから週間天気の日付を選択された時の処理
            ApiClient.getWeeklyWeather(byLocation: coordinate) { (response, errorString) in
                self.nameLabel.text = response?.timezone
                
                self.onecallSetupView(response: response?.daily?.filter { $0.dt == self.weeklySelectedItem?.dt })
            }
        } else {
            ApiClient.getCurrentLocationWeather(byLocation: coordinate) { (response, errorString) in
                self.weatherModelSetupView(response: response)
            }
        }
    }
    
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
    
    // 日付取得 
    private func getDate() -> Date {
        f.timeStyle = .none
        f.dateStyle = .short
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        return now
    }
    
    private func weatherModelSetupView(response: WeatherModel?) {
            self.nameLabel.text = response?.name
            self.dateLabel.text = self.f.string(from: self.getDate())
            self.maxTemperatureLabel.text = "最高気温：" + String(round((response?.main.temp_max)! - 273.15)) + "℃"
            self.minTemperatureLabel.text = "最低気温：" + String(round((response?.main.temp_min)! - 273.15)) + "℃"
            self.humidityLabel.text = "湿度：" + String((response?.main.humidity)!) + "%"
            self.weatherLabel.text = "天気：" + (response?.weather.first!.description)!

            self.weatherImage.setImageByDefault(with: (response?.weather.first!.icon)!)
    }
    
    private func onecallSetupView(response: [Daily]?) {
        self.cloudsLabel.isHidden = false
        self.uvIndexLabel.isHidden = false
        self.rainyPercentLabel.isHidden = false
        self.nameLabel.text = LocationManager.shared.pl
        self.maxTemperatureLabel.text = "最高気温：" + String(round((response?.first?.temp.max)! - 273.15)) + "℃"
        self.minTemperatureLabel.text = "最低気温：" + String(round((response?.first?.temp.min)! - 273.15)) + "℃"
        self.humidityLabel.text = "湿度：" + String((response?.first?.humidity)!) + "%"
        self.cloudsLabel.text = "曇り：" + String(((response?.first!.clouds)!)) + "%"
        self.uvIndexLabel.text = "UVインデックス値：" + String(((response?.first?.uvi)!)) + "%"
        self.rainyPercentLabel.text = "降水確率：" + String(((response?.first?.pop)!)) + "%"
        self.weatherLabel.text = "天気：" + (response?.first?.weather?.first?.description)!
        self.weatherImage.setImageByDefault(with: (response?.first?.weather?.first!.icon)!)
    }
    
}
