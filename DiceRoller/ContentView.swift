//
//  ContentView.swift
//  DiceRoller
//
//  Created by Dillon Redding on 11/13/25.
//

import SwiftData
import SwiftUI
internal import Combine

struct ContentView: View {
    let sideOptions = [4, 6, 8, 10, 12, 20, 100]

    let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()

    @Environment(\.modelContext) var modelContext

    @Query var rolls: [Roll]

    @State private var dice = Dice(count: 1, sides: 6)
    @State private var result = 0

    @State private var showingHistory = false
    @State private var isRolling = false
    @State private var flicks = [Int]()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                Text(result, format: .number)
                    .font(.system(size: 128))
                    .foregroundStyle(flicks.isEmpty ? .primary : .secondary)

                Spacer()

                DiceField(value: $dice)

                Button(action: roll) {
                    Label("Roll", systemImage: "dice")
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(.capsule)
                .disabled(!flicks.isEmpty)
                .sensoryFeedback(.impact(weight: .light, intensity: 1), trigger: result)
                .sensoryFeedback(.impact(flexibility: .rigid, intensity: 1), trigger: rolls.count)
            }
            .padding()
            .font(.title3.bold())
            .toolbar {
                Button("History", systemImage: "clock") {
                    showingHistory = true
                }
                .disabled(rolls.isEmpty)
            }
            .sheet(isPresented: $showingHistory) {
                HistoryView()
                    .presentationDetents([.medium, .large])
            }
            .onReceive(timer) { time in
                if !flicks.isEmpty {
                    result = flicks.removeFirst()
                    if flicks.isEmpty {
                        saveRoll()
                    }
                }
            }
        }
    }

    func roll() {
        for _ in (1...6) {
            flicks.append(dice.roll())
        }
    }

    func saveRoll() {
        let roll = Roll(dice: dice, result: result)
        modelContext.insert(roll)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Roll.self, configurations: config)

    return ContentView()
        .modelContainer(container)
}
