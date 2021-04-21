//
//  LocationManager.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/15.
//

import CoreLocation

typealias Coordinate = (lat: Double, lon:Double)

class LocationManager: NSObject {
    
    let locationManager = CLLocationManager()
    static let shared = LocationManager()
    var coordinate: CLLocationCoordinate2D?
    let geocoder = CLGeocoder()
    var placeName = ""
    
    func initialize() {
        // locationManagerのデリゲートを受け取る
        locationManager.delegate = self
        // アプリの使用中に位置情報サービスを使用する許可をリクエストする
        locationManager.requestWhenInUseAuthorization()
        // ユーザーの位置情報を1度リクエストする
        locationManager.requestLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    // 位置情報を取得・更新したときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最後に収集したlocationを取得
        if let location = locations.last {
            // 経度と緯度を取得
            coordinate = location.coordinate
            
            //逆ジオコーディング
            self.geocoder.reverseGeocodeLocation( location, completionHandler: { ( placemarks, error ) in
                if let placemark = placemarks?.first {
                    // 位置情報の名称を取得
                    self.placeName = placemark.administrativeArea!
                }
            } )
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}

