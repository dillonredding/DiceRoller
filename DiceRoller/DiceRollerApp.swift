//
//  DiceRollerApp.swift
//  DiceRoller
//
//  Created by Dillon Redding on 11/13/25.
//

import SwiftData
import SwiftUI

@main
struct DiceRollerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Roll.self)
    }
}
