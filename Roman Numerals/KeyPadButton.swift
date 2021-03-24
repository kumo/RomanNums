//
//  KeyPadButton.swift
//  Cistercian Numerals
//
//  Created by Robert Clarke on 07/02/21.
//

import SwiftUI

struct KeyPadButton: View {
    var key: String
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: { self.action(self.key) }) {
                Text(key)
                    .font(.largeTitle)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    enum ActionKey: EnvironmentKey {
        static var defaultValue: (String) -> Void { { _ in } }
    }
    
    @Environment(\.keyPadButtonAction) var action: (String) -> Void
}

extension EnvironmentValues {
    var keyPadButtonAction: (String) -> Void {
        get { self[KeyPadButton.ActionKey.self] }
        set { self[KeyPadButton.ActionKey.self] = newValue }
    }
}

struct KeyPadButton_Previews: PreviewProvider {
    static var previews: some View {
        KeyPadButton(key: "8")
            .padding()
            .frame(width: 100, height: 100)
            .previewLayout(.sizeThatFits)
    }
}
