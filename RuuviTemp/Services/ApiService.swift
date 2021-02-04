//
//  WeatherProvider.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 30.1.2021.
//

import Foundation
import RxSwift
import Alamofire

class ApiService {
    
    private let headers: HTTPHeaders = [
        "x-rapidapi-key": Keys.rapidKey.rawValue,
        "x-rapidapi-host": Keys.rapidHost.rawValue,
        "useQueryString": "true"
    ]
    
    enum failureReason: Int, Error {
        case badRequest = 400
        case unAuthorized = 401
        case notFound = 404
        case forbidden = 403
    }
    
    func getWeather(city: String) -> Observable<Weather> {
        return Observable.create { observer -> Disposable in
            AF.request("https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(Keys.owmApiKey.rawValue)")
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? failureReason.notFound)
                            return
                        }
                        do {
                            let weather = try JSONDecoder().decode(Weather.self, from: data)
                            observer.onNext(weather)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = failureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }
    
    func getCities() -> Observable<City> {
        return Observable.create { observer -> Disposable in
            AF.request("https://wft-geo-db.p.rapidapi.com/v1/geo/cities?countryIds=FI", headers: self.headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? failureReason.notFound)
                            return
                        }
                        do {
                            let cities = try JSONDecoder().decode(City.self, from: data)
                            observer.onNext(cities)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = failureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }
}
