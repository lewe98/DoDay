//
//  AktuellFirstView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 29.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct AktuellFirstView: View {
    @EnvironmentObject var coreDataFunctions: CoreDataFunctions
    @State var aufgabe1 = Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "load...", text_detail: "", text_dp: "")
    @State var aufgabe2 = Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "load...", text_detail: "", text_dp: "")
    @State var aufgabenGeladen = false
    var body: some View {
        VStack {
            Spacer()
            Text("Wähle deine heutige Aufgabe").font(.headline)
            AufgabeDetail(aufgabenGeladen: aufgabenGeladen, Aufgabe: self.aufgabe1).onTapGesture {
                self.coreDataFunctions.aktuelleAufgabeAuswaehlen(aufgabe: self.aufgabe1)
            }
            AufgabeDetail(aufgabenGeladen: aufgabenGeladen, Aufgabe: self.aufgabe2).onTapGesture {
                self.coreDataFunctions.aktuelleAufgabeAuswaehlen(aufgabe: self.aufgabe2)
            }

            Spacer()
            }
        .background(Color(UIColor .systemGroupedBackground))
        .onAppear{
            self.coreDataFunctions.verbliebeneAufgabenAnzeigen() {
                result in
                    do {
                        let aufgabenArray = try result.get()
                        self.aufgabe1 = aufgabenArray[0]!
                        self.aufgabe2 = aufgabenArray[1]!
                        // Zeigt den FirstHeuteView an
                        self.coreDataFunctions.aufgabenView = 1
                        self.aufgabenGeladen = true
                    } catch {
                        self.coreDataFunctions.aufgabenView = 3
                        self.coreDataFunctions.curUser.aufgabe = 0
                }
            }
        }
    }
}

/* struct AktuellFirstView_Previews: PreviewProvider {
    static var previews: some View {
        AktuellFirstView(aufgabenGeladen: true, Aufgabe1: "Laufe 1000 Treppenstufen.", Aufgabe2: "Steht um 12 Uhr Mittags auf und Schreie 2 Mal laut!")
    }
}
*/
