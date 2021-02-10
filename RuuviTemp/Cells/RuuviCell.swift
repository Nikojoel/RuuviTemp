//
//  RuuviCell.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 28.1.2021.
//

import UIKit

class RuuviCell: UITableViewCell {
    
    @IBOutlet weak var temp: UILabel! 
    @IBOutlet weak var humid: UILabel!
    @IBOutlet weak var pres: UILabel!
    @IBOutlet weak var rssi: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var voltage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

