//
//  ApiClient.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/15.
//

import Alamofire

protocol Requestable {
    associatedtype ResponseModel: Codable
    var url: String { get }
    var params: [String: Any] { get }
    func request(completion: @escaping (ResponseModel, String?) -> Void)
}

extension Requestable {
    func request(completion: @escaping (ResponseModel, String?) -> Void) {
        AF.request(url,
                   method: .get,
                   parameters: params,
                   headers: ApiClient.headers).validate().responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            return
                        }
                        let decoder = JSONDecoder()
                        do {
                            let model = try decoder.decode(ResponseModel.self, from: data)
                            completion(model, nil)
                        } catch {
                            print("json decorder error")
                        }
                    case .failure(let error):
                        print("Alamofire failure.\nerror: \(error)")
                    }
                }
    }
}

struct PrefectureWeatherRequest: Requestable {
    typealias ResponseModel = WeatherModel
    var url: String {
        return ApiClient.baseUrl
    }
    var params: [String : Any]
    
    init(params: [String: Any]) {
        self.params = params
    }
}

struct CurrentLocationWeatherRequest: Requestable {
    typealias ResponseModel = WeatherModel
    var url: String {
        return ApiClient.baseUrl
    }
    var params: [String : Any]
    
    init(params: [String: Any]) {
        self.params = params
    }
}

struct WeeklyWeatherRequest: Requestable {
    typealias ResponseModel = OneCallModel
    var url: String {
        return ApiClient.onecallUrl
    }
    var params: [String : Any]
    
    init(params: [String: Any]) {
        self.params = params
    }
}


class ApiClient {
    
    static let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    static let onecallUrl = "https://api.openweathermap.org/data/2.5/onecall"
    static let appId = "5dfc577c1d7d94e9e23a00431582f1ac"
    static let headers: HTTPHeaders = ["Content-Type": "application/json"]
    
    // 都道府県で取得
//    class func getPrefectureWeather(byCity prefecture: String,
//                                    completion: @escaping (_ response: WeatherModel?, _ errorString: String?) -> Void) {
//        let params: [String: Any] = ["q": prefecture, "lang": "ja", "APPID": appId]
//        requestBaseUrlApi(params, completion)
//    }
    
    // 現在地で取得
    class func getCurrentLocationWeather(byLocation coodinate: Coordinate,
                                         completion: @escaping (_ response: WeatherModel?, _ errorString: String?) -> Void) {
        let params: [String: Any] = ["lat": coodinate.lat, "lon": coodinate.lon, "lang": "ja", "APPID": appId]
        requestBaseUrlApi(params, completion)
    }
    
    // 週間天気を取得
    class func getWeeklyWeather(byLocation coodinate: Coordinate,
                                         completion: @escaping (_ response: OneCallModel?, _ errorString: String?) -> Void) {
        let params: [String: Any] = ["lat": coodinate.lat, "lon": coodinate.lon, "lang": "ja", "APPID": appId]
        requestOnecallUrlApi(params, completion)
    }
    
    private static func requestBaseUrlApi(_ params: [String: Any],
                                   _ completion: @escaping (_ response: WeatherModel?, _ errorString: String?) -> Void) {
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
                    let feed: WeatherModel = try decoder.decode(WeatherModel.self, from: data)
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
    
    private static func requestOnecallUrlApi(_ params: [String: Any],
                                   _ completion: @escaping (_ response: OneCallModel?, _ errorString: String?) -> Void) {
        AF.request(onecallUrl,
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
                    let feed: OneCallModel = try decoder.decode(OneCallModel.self, from: data)
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
