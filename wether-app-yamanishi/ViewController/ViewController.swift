//
//  ViewController.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/12.
//

import UIKit

class ViewController: UIViewController {
    
    var coordinate: Coordinate = (lat: 0.0, lon: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.initialize()
    }
    
    @IBAction func tapOnPrefectureButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TableView", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "TableView") as! TableViewController
        nextView.flag = 0 // 都道府県のTableViewを表示させるためのフラグ
        nextView.navigationItem.title = "都道府県の本日の天気"
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func tapOnCurrentLocation(_ sender: Any) {
        guard let coordinate = LocationManager.shared.coordinate else {
            showAlert()
            return
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "WeatherDetail", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "WeatherDetail") as! WeatherDetailViewController
        nextView.coordinate = (lat: coordinate.latitude, lon: coordinate.longitude)
        nextView.navigationItem.title = "現在地の本日の天気"
        self.present(nextView, animated: true, completion: nil)
    }
    
    private func showAlert() {
        let alert: UIAlertController = UIAlertController(title: "位置情報が取得されていません。", message: "位置情報を取得しますか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default) {_ in
        // 設定画面に移行
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
              return
            }
            if UIApplication.shared.canOpenURL(settingsUrl)  {
              if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
              }
              else  {
                UIApplication.shared.openURL(settingsUrl)
              }
            }
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapOnWeeklyWeatherButton(_ sender: Any) {
        guard let coordinate = LocationManager.shared.coordinate else {
            showAlert()
            return
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "TableView", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "TableView") as! TableViewController
        nextView.flag = 1 // 週間天気ビューを表示させるためのフラグ
        nextView.navigationItem.title = "現在地の週間天気"
        
        DispatchQueue.main.async{
            ApiClient.getWeeklyWeather(byLocation: self.coordinate) { (response, errString) in
                nextView.tableCountNum = (response?.daily!.count)!
                response?.daily?.forEach({ (Daily) in
                    nextView.weeklyLists.append((dt: Daily.dt, dateStr: nextView.unixToString(date: TimeInterval(Daily.dt))))
                })
                self.navigationController?.pushViewController(nextView, animated: true)
            }
        }
    }
    
}

