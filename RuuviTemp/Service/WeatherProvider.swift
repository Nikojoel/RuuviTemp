//
//  WeatherProvider.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 30.1.2021.
//

import Foundation
import RxSwift
import Alamofire

class WeatherProvider {
    
    enum failureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
        case forbidden = 403
    }
    
    func getWeather() -> Observable<Weather> {
        return Observable.create { observer -> Disposable in
            AF.request("https://api.openweathermap.org/data/2.5/weather?q=Helsinki&units=metric&appid=\(Keys.apiKey.rawValue)")
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
}
