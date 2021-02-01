//
//  RuuviTableViewController.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 28.1.2021.
//

import UIKit
import BTKit

class RuuviTableViewController: UITableViewController {
    private var ruuviTagsSet = Set<RuuviTag>()
    private var ruuviTags = [RuuviTag]()
    private var nameSet = Set<NamedRuuvi>()
    private var names = [NamedRuuvi]()

    override func viewDidLoad() {
        super.viewDidLoad()
        BTKit.scanner.scan(self) { (observer, device) in
            if let ruuviTag = device.ruuvi?.tag {
                observer.ruuviTagsSet.update(with: ruuviTag)
                self.nameSet.update(with: NamedRuuvi(name: "-", mac: ruuviTag.mac ?? "00"))
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.ruuviTags = self.ruuviTagsSet.sorted(by: { $0.mac ?? "aa" < $1.mac ?? "bb" })
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ruuviTags.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
        guard let tagMAC = ruuviTags[indexPath.row].mac else {
            return
        }
        print(tagMAC)
        setRuuviName(mac: tagMAC)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let tag = ruuviTags[indexPath.row]
        cell.temp.text = "\(tag.celsius ?? 0) °C"
        cell.humid.text = "\(tag.humidity ?? 0) %"
        cell.pres.text = "\(tag.pressure ?? 0) hPa"
        cell.rssi.text = "\(tag.rssi) dBM"
        cell.accX.text = "\(tag.accelerationX ?? 0) G"
        cell.accY.text = "\(tag.accelerationY ?? 0) G"
        cell.accZ.text = "\(tag.accelerationZ ?? 0) G"
        cell.name.text = "--"
        return cell
    }
    
    private func setRuuviName(mac: String?) {
        let alert = UIAlertController(title: "Set name", message: "Choose a name for this RuuviTag", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style {
              case .default:
                    let name = alert.textFields?[0].text ?? "Undefined"
                    self.nameSet.update(with: NamedRuuvi(name: name, mac: mac ?? "null"))
                    self.names = self.nameSet.sorted(by: { $0.mac < $1.mac })
                    print("default")
              case .cancel:
                    print("cancel")
              case .destructive:
                    print("destructive")
              @unknown default:
                return
              }}))
        self.present(alert, animated: true, completion: nil)
    }
}
