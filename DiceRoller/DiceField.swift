//
//  DiceField.swift
//  DiceRoller
//
//  Created by Dillon Redding on 11/16/25.
//

import SwiftUI

struct DiceField: View {
    @Binding var value: Dice

    let sideOptions = [4, 6, 8, 10, 12, 20, 100]

    var body: some View {
        HStack {
            Menu {
                Picker("Number of dice", selection: $value.count) {
                    ForEach(1...20, id: \.self) {
                        Text("\($0)")
                    }
                }
            } label: {
                Text("\(value.count)")
                    .padding(.horizontal, 8)
            }
            .id(value.count)

            Rectangle()
                .frame(width: 2, height: 28)
                .foregroundStyle(.secondary)

            Menu {
                Picker("Number of sides", selection: $value.sides) {
                    ForEach(sideOptions, id: \.self) {
                        Text("d\($0)")
                    }
                }
            } label: {
                Text("d\(value.sides)")
                    .padding(.horizontal, 8)
            }
            .id("d\(value.sides)")

            Rectangle()
                .frame(width: 2, height: 28)
                .foregroundStyle(.secondary)

            Menu {
                Picker("Modifier", selection: $value.modifier) {
                    ForEach(-10...10, id: \.self) {
                        Text(Modifier($0).formatted())
                    }
                }
            } label: {
                Text(value.modifier.formatted())
            }
            .id(value.modifier.formatted())
            .padding(.horizontal, 8)
        }
        .padding()
        .background(.white)
        .foregroundStyle(.blue)
        .clipShape(.capsule)
    }
}

#Preview {
    @Previewable @State var dice = Dice.example
    DiceField(value: $dice)
}
