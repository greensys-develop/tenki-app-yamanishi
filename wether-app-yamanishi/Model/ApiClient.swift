//
//  ApiClient.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/15.
//

import Alamofire

class ApiClient {
    
    static let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    static let appId = "5dfc577c1d7d94e9e23a00431582f1ac"
    static let headers: HTTPHeaders = ["Content-Type": "application/json"]
    
    // 都道府県で取得
    class func getPrefectureWeather(byCity prefecture: String,
                              completion: @escaping (_ response: weather?, _ errorString: String?) -> Void) {
        let params: [String: Any] = ["q": prefecture, "lang": "ja", "APPID": appId]
        requestApi(params, completion)
    }
    
    // 現在地で取得
    class func getCurrentLocationWeather(byLocation coodinate: Coordinate, completion: @escaping (_ response: weather?, _ errorString: String?) -> Void) {
        let params: [String: Any] = ["lat": coodinate.lat, "lon": coodinate.lon, "lang": "ja", "APPID": appId]
        requestApi(params, completion)
    }
    
    private static func requestApi(_ params: [String: Any],
                                   _ completion: @escaping (_ response: weather?, _ errorString: String?) -> Void) {
        AF.request(baseUrl,
                   method: .get,
                   parameters: params,
                   headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                guard let data = response.data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let feed: weather = try decoder.decode(weather.self, from: data)
                    completion(feed, nil)
                } catch {
                    print("json decorder error")
                    print(error)
                }
            case .failure(let error):
                print("Alamofire failure.\nerror: \(error)")
            }
        }
    }
}
