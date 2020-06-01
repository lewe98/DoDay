//
//  AktuellFirstView.swift
//  iTask
//
//  Created by Lewe Lorenzen on 29.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct AktuellFirstView: View {
    var Aufgabe1: String
    var Aufgabe2: String
    
    var body: some View {
        VStack {
            Spacer()
            Text("Wähle deine heutige Aufgabe").font(.headline)
            AufgabeDetail(Aufgabe: Aufgabe1)
            AufgabeDetail(Aufgabe: Aufgabe2)
            Spacer()
        }
        .background(Color(UIColor .systemGroupedBackground))
    }
}

struct AktuellFirstView_Previews: PreviewProvider {
    static var previews: some View {
        AktuellFirstView(Aufgabe1: "Laufe 1000 Treppenstufen.", Aufgabe2: "Steht um 12 Uhr Mittags auf und Schreie 2 Mal laut!")
    }
}
