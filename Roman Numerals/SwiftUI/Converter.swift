//
//  Converter.swift
//  Roman Numerals
//
//  Created by Robert Clarke on 13/06/21.
//  Copyright © 2021 Robert Clarke. All rights reserved.
//

import Foundation

extension Int {
    func toRoman() -> String? {
        guard self > 0 else { return nil }
        
        let values = [("M", 1000), ("CM", 900), ("D", 500), ("CD", 400), ("C", 100),
                      ("XC", 90), ("L", 50), ("XL", 40), ("X", 10),
                      ("IX", 9), ("V", 5), ("IV", 4), ("I", 1)]
        
        var number = self
        var result = ""
        
        for (romanChar, arabicValue) in values {
            // not really needed, but it could be nice for logging
            guard number >= arabicValue else {
                continue
            }
            
            while number >= arabicValue {
                result += romanChar
                number -= arabicValue
            }
        }
        
        return result
    }
}

enum RomanNumeral {
    init?(from number: Int) {
        guard number > 0 && number < 4000 else {
            return nil
        }
        
        let values = [("M", 1000), ("CM", 900), ("D", 500), ("CD", 400), ("C", 100),
                      ("XC", 90), ("L", 50), ("XL", 40), ("X", 10),
                      ("IX", 9), ("V", 5), ("IV", 4), ("I", 1)]
        var workingNumber = number
        var result = ""
        
        for (romanChar, arabicValue) in values {
            while workingNumber >= arabicValue {
                result += romanChar
                workingNumber -= arabicValue
            }
        }
        
        self = RomanNumeral.valid(romanNumeral: result, arabicNumber: number)
    }
    
    init?(from string: String) {
        guard string.isEmpty == false else {
            return nil
        }
        
        // NOTE: this will only check if the letters exist and not that the string is only these letters
        let validChars = CharacterSet(charactersIn: "MDCLXVI")
        guard string.uppercased().rangeOfCharacter(from: validChars) != nil else {
            return nil
        }
        
        let values = [("M", 1000), ("CM", 900), ("D", 500), ("CD", 400), ("C", 100),
                      ("XC", 90), ("L", 50), ("XL", 40), ("X", 10),
                      ("IX", 9), ("V", 5), ("IV", 4), ("I", 1)]
        var workString = string.uppercased()
        var result = 0
        
        for (romanChar, arabicValue) in values {
            let range = romanChar.startIndex ..< romanChar.endIndex
            
            while workString.hasPrefix(romanChar) {
                result += arabicValue
                workString.removeSubrange(range)
            }
        }
        
        guard workString.isEmpty else {
            print("not empty")
            return nil
        }
        
        // let's double check that the result produces the same string
        guard let validRomanNumeral = result.toRoman() else {
            return nil
        }
        
        if validRomanNumeral == string {
            self = RomanNumeral.valid(romanNumeral: validRomanNumeral, arabicNumber: result)
        } else {
            self = RomanNumeral.converted(romanNumeral: validRomanNumeral, arabicNumber: result, originalRomanNumeral: string.uppercased())
        }
    }
    
    case valid(romanNumeral: String, arabicNumber: Int)
    case converted(romanNumeral: String, arabicNumber: Int, originalRomanNumeral: String)
    
    var arabicNumber: Int {
        switch self {
        case .valid(romanNumeral: _, arabicNumber: let x):
            return x
        case .converted(romanNumeral: _, arabicNumber: let x, originalRomanNumeral: _):
            return x
        }
    }
    
    var romanNumeral: String {
        switch self {
        case .valid(romanNumeral: let x, arabicNumber: _):
            return x
        case .converted(romanNumeral: let x, arabicNumber: _, originalRomanNumeral: _):
            return x
        }
    }
    
}
