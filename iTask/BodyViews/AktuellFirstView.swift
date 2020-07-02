//
//  AktuellFirstView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 29.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct AktuellFirstView: View {
    let aufgabenGeladen: Bool
    var Aufgabe1: String
    var Aufgabe2: String
    
    var body: some View {
        VStack {
            Spacer()
            Text("Wähle deine heutige Aufgabe").font(.headline)
            AufgabeDetail(aufgabenGeladen: aufgabenGeladen, Aufgabe: Aufgabe1)
            AufgabeDetail(aufgabenGeladen: aufgabenGeladen, Aufgabe: Aufgabe2)

            Spacer()
        }
        .background(Color(UIColor .systemGroupedBackground))
    }
}

struct AktuellFirstView_Previews: PreviewProvider {
    static var previews: some View {
        AktuellFirstView(aufgabenGeladen: true, Aufgabe1: "Laufe 1000 Treppenstufen.", Aufgabe2: "Steht um 12 Uhr Mittags auf und Schreie 2 Mal laut!")
    }
}
