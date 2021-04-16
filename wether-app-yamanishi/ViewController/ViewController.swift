//
//  ViewController.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/12.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.initialize()
    }
    
    @IBAction func tapOnPrefectureButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "PrefectureWeather", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "PrefectureWeather") as! PrefectureWeatherTableViewController
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

}

