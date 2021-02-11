//
//  WeatherViewController.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 30.1.2021.
//

import Foundation
import UIKit
import RxSwift
import AlamofireImage

class WeatherViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!
    
    private let service = ApiService()
    private let disposeBag = DisposeBag()
    private let calendar = Calendar.current
    private var data = [String]()
    private var cities = [City]()
    private var weathers = [Weather]()
    private var weatherSet = Set<Weather>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        service.getCities().subscribe(
            onNext: { city in
                self.data.append(contentsOf: city.data)
                self.pickerView.reloadAllComponents()
            },
            onError: { error in
                print(error)
            }
        ).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherCell
        let data = weathers[indexPath.row]
        let icon = getWeatherType(type: data.weather[0].main)
        let img = getWeatherImage(type: data.weather[0].main)
        
        let bg = UIImageView(image: UIImage(named: img))
        bg.frame = cell.frame
        cell.backgroundView = bg
        
        print(data)
        cell.temp.text = "\(data.main.temp) °C"
        cell.name.text = data.name
        cell.high.text = "High of \(data.main.temp_max) °C"
        cell.low.text = "Low of \(data.main.temp_min) °C"
        cell.feels.text = "Feels like \(data.main.feels_like) °C"
        cell.humid.text = "\(data.main.humidity) %"
        cell.pres.text = "\(data.main.pressure) hPa"
        cell.visib.text = "\(data.visibility / 1000) km"
        cell.wind.text = "\(data.wind["speed"] ?? 0) m/s"
        cell.dir.text = "\(WindDirection(data.wind["deg"] ?? 0))"
        cell.sSet.text = getDate(value: data.sys.sunset)
        cell.sRise.text = getDate(value: data.sys.sunrise)
        cell.desc.text = data.weather[0].description
        cell.img.image = UIImage(systemName: icon)
        return cell
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
                self.weatherSet.update(with: weather)
                self.weathers = self.weatherSet.sorted(by: { $0.name < $1.name})
                self.tableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: true)
                self.tableView.reloadData()
            },
            onError: { error in
                print(error)
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
    
    func getWeatherImage(type: String) -> String {
        switch type {
        case "Clear":
            return "1"
        case "Clouds":
            return "2"
        case "Snow":
            return "3"
        case "Rain":
            return "4"
        default:
            return "1"
        }
    }
    
    func getWeatherType(type: String) -> String {
        switch type {
        case "Clouds":
            return "cloud.fill"
        case "Clear":
            return "sun.max.fill"
        case "Snow":
            return "snow"
        case "Rain":
            return "cloud.rain.fill"
        case "Drizzle":
            return "cloud.drizzle.fill"
        case "Thunderstorm":
            return "cloud.bolt.fill"
        default:
            return "xmark.icloud.fill"
        }
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
