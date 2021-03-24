//
//  SwiftUIViewHostingController.swift
//  Roman Numerals
//
//  Created by Robert Clarke on 24/03/21.
//  Copyright © 2021 Robert Clarke. All rights reserved.
//

import Foundation
import SwiftUI

//Create a UIHostingController class that hosts your SwiftUI view
@available(iOS 14.0, *)
class SwiftUIViewHostingController: UIHostingController<CrosswordSolverView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: CrosswordSolverView())
    }
}
