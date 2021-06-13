//
//  RomanKeyPad.swift
//  Roman Numerals
//
//  Created by Robert Clarke on 13/06/21.
//  Copyright © 2021 Robert Clarke. All rights reserved.
//

import SwiftUI

struct RomanKeyPad: View {
    @Binding var string: String
    
    var body: some View {
        VStack(spacing: 1) {
            KeyPadRow(keys: ["C", "D", "I"])
            KeyPadRow(keys: ["L", "M", "V"])
            KeyPadRow(keys: ["", "X", "⌫"])
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

struct RomanKeyPad_Previews: PreviewProvider {
    @State static var string = "MMM"
    static var previews: some View {
        RomanKeyPad(string: $string)
    }
}
