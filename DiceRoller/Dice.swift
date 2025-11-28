//
//  Dice.swift
//  DiceRoller
//
//  Created by Dillon Redding on 11/16/25.
//

import Foundation

typealias Modifier = Int

extension Modifier {
    func formatted() -> String {
        self.formatted(.number.sign(strategy: .always(includingZero: false)))
    }
}

struct Dice: nonisolated Codable, CustomStringConvertible {
    var count: Int
    var sides: Int
    var modifier: Modifier = 0

    var description: String {
        let suffix = modifier == 0 ? "" : modifier.formatted()
        return "\(count)d\(sides)\(suffix)"
    }

    func roll() -> Int {
        let total = (1...count).reduce(0) { total, _ in
            total + Int.random(in: 1...sides)
        }
        return total + modifier
    }

    static let example = Dice(count: 2, sides: 6, modifier: 3)
}
