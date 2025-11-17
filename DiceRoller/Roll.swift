//
//  Roll.swift
//  DiceRoller
//
//  Created by Dillon Redding on 11/13/25.
//

import Foundation
import SwiftData

@Model
class Roll {
    var dice: Dice
    var result: Int
    var date: Date

    init(dice: Dice, result: Int, date: Date = .now) {
        self.dice = dice
        self.result = result
        self.date = date
    }
}
