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

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sSet: UILabel!
    @IBOutlet weak var sRise: UILabel!
    @IBOutlet weak var dir: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var visib: UILabel!
    @IBOutlet weak var humid: UILabel!
    @IBOutlet weak var pres: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var feels: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var progBar: UIActivityIndicatorView!
    
    private let service = ApiService()
    private let disposeBag = DisposeBag()
    private let calendar = Calendar.current
    private var data: [String] = []
    private var cities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        progBar.startAnimating()
        
        service.getCities().subscribe(
            onNext: { city in
                self.data.append(contentsOf: city.data)
                self.pickerView.reloadAllComponents()
                self.progBar.stopAnimating()
                self.progBar.hidesWhenStopped = true
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
                self.updateWeather(weather: weather)
            },
            onError: { error in
                print(error)
                self.temp.text = "Not found"
                self.name.text = "--"
            }
        ).disposed(by: disposeBag)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func getDate(value: Int) -> String {
        let hours = self.calendar.dateComponents([.hour], from: Date(timeIntervalSince1970: TimeInterval(value))).hour
        let minutes = self.calendar.dateComponents([.minute], from: Date(timeIntervalSince1970: TimeInterval(value))).minute
        return "\(hours ?? 0):\(minutes ?? 0)"
    }
    
    func updateWeather(weather: Weather) {
        print(weather)
        temp.text = "\(weather.main.temp) °C"
        name.text = weather.name
        high.text = "\(weather.main.temp_max) °C"
        low.text = "\(weather.main.temp_min) °C"
        feels.text = "\(weather.main.feels_like) °C"
        humid.text = "\(weather.main.humidity) %"
        pres.text = "\(weather.main.pressure) hPa"
        visib.text = "\(weather.visibility / 1000) km"
        wind.text = "\(weather.wind["speed"] ?? 0) m/s"
        dir.text = "\(WindDirection(weather.wind["deg"] ?? 0))"
        sSet.text = getDate(value: weather.sys.sunset)
        sRise.text = getDate(value: weather.sys.sunrise)
        desc.text = weather.weather[0].description
    }
}

enum WindDirection: String, CaseIterable {
    case n, nne, ne, ene, e, ese, se, sse, s, ssw, sw, wsw, w, wnw, nw, nnw

}

extension WindDirection: CustomStringConvertible {
    init<D: BinaryFloatingPoint>(_ direction: D) {
        self = Self.allCases[Int((direction.angle+11.25).truncatingRemainder(dividingBy: 360/22.5))]
    }
    
    var description: String { rawValue.uppercased() }
}

extension BinaryFloatingPoint {
    var angle: Self {
        (truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
    }
    var direction: WindDirection { .init(self) }
}
