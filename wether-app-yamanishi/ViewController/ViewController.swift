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
        let storyboard: UIStoryboard = UIStoryboard(name: "WeatherDetail", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "WeatherDetail") as! WeatherDetailViewController
        guard let coordinate = LocationManager.shared.coordinate else {
            return
        }
        nextView.coordinate = (lat: coordinate.latitude, lon: coordinate.longitude)
        self.present(nextView, animated: true, completion: nil)
    }

}

