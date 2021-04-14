//
//  WeatherDetailViewController.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/13.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherDetailViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var selectedItem: (name: String, queryName: String)!
    var image: UIImage!
    let f = DateFormatter()
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    let appId = "5dfc577c1d7d94e9e23a00431582f1ac"
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = selectedItem {
            getPrefectureWeather(item: item)
        } else {
            // locationManagerのデリゲートを受け取る
            locationManager.delegate = self
            // アプリの使用中に位置情報サービスを使用する許可をリクエストする
            locationManager.requestWhenInUseAuthorization()
            // ユーザーの位置情報を1度リクエストする
            locationManager.requestLocation()
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
    
    private func getAPI(url: String) {
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {(response) in
            
            switch response.result {
                case .success:
                    let json:JSON = JSON(response.data as Any)
                    
                    let name = json["name"].string!
                    let temp_min = json["main"]["temp_min"].double! - 273.15
                    let temp_max = json["main"]["temp_max"].double! - 273.15
                    let humidity = json["main"]["humidity"].int!
                    let weather = json["weather"][0]["description"].string!
                    let icon = json["weather"][0]["icon"].string!
                    
                    self.nameLabel.text = name
                    self.dateLabel.text = self.f.string(from: self.getDate())
                    self.maxTemperatureLabel.text = "最高気温：" + String(round(temp_max)) + "℃"
                    self.minTemperatureLabel.text = "最低気温：" + String(round(temp_min)) + "℃"
                    self.humidityLabel.text = "湿度：" + String(humidity) + "%"
                    self.weatherLabel.text = "天気：" + weather
                    
                    guard let url = URL(string: "https://openweathermap.org/img/w/\(icon).png") else { return }
                    self.weatherImage.setImageByDefault(with: url)
                    
                case .failure(_):
                    return
            }
        }
    }
    
    // 都道府県で取得
    private func getPrefectureWeather(item: (name: String, queryName: String)) {
        let url = baseUrl + "?q=" + item.queryName + "&lang=ja&appid=" + appId
        getAPI(url: url)
    }
    
    // 現在地で取得
    private func getCurrentLocationWeather(lat: Double, lon: Double) {
        let url1 = baseUrl + "?lat=" + String(lat) + "&lon=" + String(lon)
        let url2 = "&lang=ja&appid=" + appId
        let url = url1 + url2
        getAPI(url: url)
    }
    
}

extension UIImageView {

    func setImageByDefault(with url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if error == nil, case .some(let result) = data, let image = UIImage(data: result) {
               //ここでメインスレッド実行するように記述(無いとサブスレッドで実行されて落ちる)
                DispatchQueue.main.async {
                    self?.image = image
                }

            } else {
                // error handling
                print("error", error!)
            }
        }.resume()
    }

}

extension WeatherDetailViewController: CLLocationManagerDelegate {
    // 位置情報を取得・更新したときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最後に収集したlocationを取得
        if let location = locations.last {
            // 経度と緯度を取得
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
//            print("lat: \(lat), lon: \(lon)")
            getCurrentLocationWeather(lat: lat, lon: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}
