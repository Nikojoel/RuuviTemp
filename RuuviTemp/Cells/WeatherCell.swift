//
//  WeatherCell.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 10.2.2021.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var feels: UILabel!
    @IBOutlet weak var sSet: UILabel!
    @IBOutlet weak var sRise: UILabel!
    @IBOutlet weak var dir: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var visib: UILabel!
    @IBOutlet weak var humid: UILabel!
    @IBOutlet weak var pres: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
