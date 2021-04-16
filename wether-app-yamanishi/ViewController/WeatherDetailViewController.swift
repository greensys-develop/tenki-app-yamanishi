//
//  WeatherDetailViewController.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/13.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    var selectedItem: (name: String, queryName: String)!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = selectedItem {
            ApiClient.getPrefectureWeather(byCity: item.queryName) { response, errorString in
                self.setupView(response: response)
            }
        } else {
            ApiClient.getCurrentLocationWeather(byLocation: coordinate) { (response, errorString) in
                self.setupView(response: response)
            }
//            ApiClient.getFiveDaysAgoWeather(byLocation: coordinate) { (response, errString) in
//                print(response!)
//            }
        }
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
    
    private func setupView(response: WeatherModel?) {
            self.nameLabel.text = response?.name
            self.dateLabel.text = self.f.string(from: self.getDate())
            self.maxTemperatureLabel.text = "最高気温：" + String(round((response?.main.temp_max)! - 273.15)) + "℃"
            self.minTemperatureLabel.text = "最低気温：" + String(round((response?.main.temp_min)! - 273.15)) + "℃"
            self.humidityLabel.text = "湿度：" + String((response?.main.humidity)!) + "%"
            self.weatherLabel.text = "天気：" + (response?.weather.first!.description)!

            self.weatherImage.setImageByDefault(with: (response?.weather.first!.icon)!)
    }
    
}
