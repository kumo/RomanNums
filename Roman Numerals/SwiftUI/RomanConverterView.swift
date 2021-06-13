//
//  RomanConverterView.swift
//  Roman Numerals
//
//  Created by Robert Clarke on 13/06/21.
//  Copyright © 2021 Robert Clarke. All rights reserved.
//

import SwiftUI

class RomanConverterData: ObservableObject {
    @Published var conversion = ""
    @Published var screenInput = " "
    
    @Published var input = "" {
        didSet {
            if let result = RomanNumeral.init(from: input) {
                
                switch result {
                case .valid(romanNumeral: let romanNumeral, arabicNumber: let arabicNumber):
                    conversion = String(arabicNumber)
                    
                    screenInput = romanNumeral
                case .converted(romanNumeral: _, arabicNumber: _, originalRomanNumeral: _):
                    
                    input = screenInput
                }
            } else {
                input = String(input.dropLast())
            }
        }
    }
}


struct RomanConverterView: View {
    @StateObject var data = RomanConverterData()
    
    var body: some View {
        VStack {
            
            Text(data.conversion)
                .font(.largeTitle)
            
            VStack {
                Divider()
                
                HStack {
                    Spacer()
                    Text(data.screenInput)
                        .font(.largeTitle)
                }.padding([.leading, .trailing])
                
                Divider()
            }
            
            Spacer()
            
            RomanKeyPad(string: $data.input)
        }    }
}

struct RomanConverterView_Previews: PreviewProvider {
    static var previews: some View {
        RomanConverterView()
    }
}
