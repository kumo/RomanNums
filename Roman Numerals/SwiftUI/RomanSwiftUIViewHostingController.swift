//
//  RomanSwiftUIViewHostingController.swift
//  Roman Numerals
//
//  Created by Robert Clarke on 13/06/21.
//  Copyright © 2021 Robert Clarke. All rights reserved.
//

import Foundation

import SwiftUI

//Create a UIHostingController class that hosts your SwiftUI view
@available(iOS 14.0, *)
class RomanSwiftUIViewHostingController: UIHostingController<RomanConverterView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: RomanConverterView())
    }
}
