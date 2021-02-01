//
//  WeatherViewController.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 30.1.2021.
//

import Foundation
import UIKit
import RxSwift

class WeatherViewController: UIViewController {
    
    private let weatherProvider = WeatherProvider()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherProvider.getWeather().subscribe(
            onNext: { weather in
                print(weather)
            },
            onError: { error in
                print(error)
            }
        ).disposed(by: disposeBag)
    }
    
}
