//
//  HistoryView.swift
//  DiceRoller
//
//  Created by Dillon Redding on 11/13/25.
//

import SwiftData
import SwiftUI

struct HistoryView: View {
    @Query(sort: [SortDescriptor(\Roll.date, order: .reverse)]) var rolls: [Roll]

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @State private var showingClearHistoryConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(rolls) { roll in
                    VStack(alignment: .leading) {
                        Text(roll.dice.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(roll.result)")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button("Clear") { showingClearHistoryConfirmation = true }
                        .foregroundStyle(.red)
                }
            }
            .confirmationDialog("Clear History", isPresented: $showingClearHistoryConfirmation) {
                Button("Clear History", role: .destructive, action: clear)
            } message: {
                Text("All rolls will be deleted. This action cannot be undone.")
            }
        }
    }

    func clear() {
        for roll in rolls {
            modelContext.delete(roll)
        }
        dismiss()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(rolls[index])
        }
        if rolls.isEmpty {
            dismiss()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Roll.self, configurations: config)

    let dice = Dice.example
    container.mainContext.insert(Roll(dice: dice, result: dice.roll()))
    container.mainContext.insert(Roll(dice: dice, result: dice.roll()))
    container.mainContext.insert(Roll(dice: dice, result: dice.roll()))
    container.mainContext.insert(Roll(dice: dice, result: dice.roll()))
    container.mainContext.insert(Roll(dice: dice, result: dice.roll()))

    return HistoryView()
        .modelContainer(container)
}
