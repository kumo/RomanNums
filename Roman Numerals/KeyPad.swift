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

struct KeyPad: View {
    @Binding var string: String
    
    var body: some View {
        VStack(spacing: 1) {
            KeyPadRow(keys: ["M", "C", "V"])
            KeyPadRow(keys: ["?", "5", "6"])
            KeyPadRow(keys: ["7", "8", "9"])
            KeyPadRow(keys: ["", "0", "⌫"])
        }.environment(\.keyPadButtonAction, self.keyWasPressed(_:))
        .background(Color.clear)
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

struct KeyPad_Previews : PreviewProvider {
    @State static var string = "1234"
    static var previews: some View {
        Group {
            KeyPad(string: $string)
        }
    }
}
