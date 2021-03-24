//
//  CrosswordSolverView.swift
//  Roman Numerals
//
//  Created by Robert Clarke on 24/03/21.
//  Copyright © 2021 Robert Clarke. All rights reserved.
//

import SwiftUI

class CrosswordSolverData: ObservableObject {
    @Published var results: [String] = []
    @Published var input = " " {
        didSet {
            let solver = CrosswordSolver()
            results = solver.searchNew(string: input)
        }
    }
}

@available(iOS 14.0, *)
struct CrosswordSolverView: View {
    @StateObject var data = CrosswordSolverData()
    
    var body: some View {
        VStack {
            Text("Results: " + String(data.results.count))
            
            List(data.results, id: \.self) { string in
                Text(string)
            }
            
            VStack {
                Divider()
                
                HStack {
                    Spacer()
                    Text(data.input)
                        .font(.largeTitle)
                }.padding([.leading, .trailing])
                
                Divider()
            }
            
            Spacer()
            
            KeyPad(string: $data.input)
        }
    }
}

@available(iOS 14.0, *)
struct CrosswordSolverView_Previews: PreviewProvider {
    static var previews: some View {
        CrosswordSolverView()
    }
}
