//
//  WeatherViewController.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 30.1.2021.
//

import Foundation
import UIKit
import RxSwift

class WeatherViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    private let service = ApiService()
    private let disposeBag = DisposeBag()
    var data: [String] = []
    private var cities: [CityData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        
        service.getCities().subscribe(
            onNext: { city in
                self.data.append(city.data[0].city)
                self.data.append(city.data[1].city)
                self.pickerView.reloadAllComponents()
            },
            onError: { error in
                print(error)
            }
        ).disposed(by: disposeBag)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        service.getWeather(city: data[row]).subscribe(
            onNext: { weather in
                print(weather)
            },
            onError: { error in
                print(error)
            }
        ).disposed(by: disposeBag)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(cities.count)
        return data[row]
    }
}
