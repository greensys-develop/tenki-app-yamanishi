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

    func request(completion: ((ResponseModel) -> ())?)
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

extension Requestable {
    func request(completion: ((ResponseModel) -> ())?) {
        AF
            .request(url,
                     method: .get,
                     parameters: params,
                     headers: ApiClient.headers).validate()
            .response(completionHandler: { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        return
                    }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let feed = try decoder.decode(ResponseModel.self, from: data)
//                        print(feed)
                        completion?(feed)
                    } catch {
                        print("json decorder error")
                        print(error)
                    }
                case .failure(let error):
                    print("Alamofire failure.\nerror: \(error)")
                }
            })
    }
}

class ApiClient {
    
    static let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    static let onecallUrl = "https://api.openweathermap.org/data/2.5/onecall"
    static let appId = "5dfc577c1d7d94e9e23a00431582f1ac"
    static let headers: HTTPHeaders = ["Content-Type": "application/json"]

}
