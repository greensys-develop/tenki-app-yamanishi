//
//  WeatherDetailViewController.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/13.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherDetailViewController: UIViewController {
    
    var selectedItem: (name: String, queryName: String)!
    var image: UIImage!
    let f = DateFormatter()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 日付取得
        f.timeStyle = .none
        f.dateStyle = .short
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(selectedItem.queryName)&lang=ja&appid=5dfc577c1d7d94e9e23a00431582f1ac#"

        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {(response) in
            
            switch response.result {
                case .success:
                    let json:JSON = JSON(response.data as Any)
                    
                    let temp_min = json["main"]["temp_min"].double! - 273.15
                    let temp_max = json["main"]["temp_max"].double! - 273.15
                    let humidity = json["main"]["humidity"].int!
                    let weather = json["weather"][0]["description"].string!
                    let icon = json["weather"][0]["icon"].string!
                    
                    self.nameLabel.text = self.selectedItem.name
                    self.dateLabel.text = self.f.string(from: now)
                    self.maxTemperatureLabel.text = "最高気温：" + String(round(temp_max)) + "℃"
                    self.minTemperatureLabel.text = "最低気温：" + String(round(temp_min)) + "℃"
                    self.humidityLabel.text = "湿度：" + String(humidity) + "%"
                    self.weatherLabel.text = "天気：" + weather
                    
                    if icon == "01d" || icon == "02d" {
                        self.image = UIImage(named:"tenki_hare")
                    } else if icon == "03d" || icon == "04d" {
                        self.image = UIImage(named:"tenki_kumori")
                    } else if icon == "09d" || icon == "10d" {
                        self.image = UIImage(named:"tenki_ame")
                    } else if icon == "11d" {
                        self.image = UIImage(named:"tenki_raiu")
                    } else if icon == "50d" {
                        self.image = UIImage(named:"tenki_kiri")
                    }
                    self.weatherImage.image = self.image
                    
                case .failure(_):
                    return
            }
        }
    }
    
    @IBAction func tapOnCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
