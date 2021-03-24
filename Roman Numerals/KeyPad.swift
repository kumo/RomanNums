//
//  KeyPad.swift
//  Cistercian Numerals
//
//  Created by Robert Clarke on 07/02/21.
//

import SwiftUI

struct KeyPadRow: View {
    var keys: [String]
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(keys, id: \.self) { key in
                KeyPadButton(key: key)
            }
        }
    }
}

struct CrosswordKeyPad: View {
    @Binding var string: String
    
    var body: some View {
        VStack(spacing: 1) {
            KeyPadRow(keys: ["C", "D", "I"])
            KeyPadRow(keys: ["L", "M", "V"])
            KeyPadRow(keys: ["?", "X", "⌫"])
        }.environment(\.keyPadButtonAction, self.keyWasPressed(_:))
        .background(Color(UIColor.systemGray3))
        .padding(0)
    }
    
    private func keyWasPressed(_ key: String) {
        switch key {
        case "⌫":
            string.removeLast()
            if string.isEmpty { string = " " }
        case _ where string == " ": string = key
        default: if string.count < 17 { string += key }
        }
    }
}

struct CrosswordKeyPad_Previews : PreviewProvider {
    @State static var string = "M???"
    static var previews: some View {
        Group {
            CrosswordKeyPad(string: $string)
        }
    }
}
