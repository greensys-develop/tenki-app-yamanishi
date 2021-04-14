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
    }
    
    @IBAction func tapOnPrefectureButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "PrefectureWeather", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "PrefectureWeather") as! PrefectureWeatherTableViewController
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    


}

