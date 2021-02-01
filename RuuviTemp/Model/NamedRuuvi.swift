//
//  Name.swift
//  RuuviTemp
//
//  Created by Niko Holopainen on 29.1.2021.
//

import Foundation

struct NamedRuuvi: Hashable {
    var name: String
    var mac: String
    
    static func == (lhs: NamedRuuvi, rhs: NamedRuuvi) -> Bool {
        return lhs.mac == rhs.mac
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(mac)
    }
}
