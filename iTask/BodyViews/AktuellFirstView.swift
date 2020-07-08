//
//  AktuellFirstView.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 29.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct AktuellFirstView: View {
    @EnvironmentObject var coreDataFunctions: CoreDataFunctions
    @State var aufgabe1 = Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "load...", text_detail: "", text_dp: "")
    @State var aufgabe2 = Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "load...", text_detail: "", text_dp: "")
    /// Ist ein Bool, der anziegt, ob die Aufgaben geladen werden konnten.
    @State var aufgabenGeladen = false
    /// Animiert die 1. Aufgabe.
    @State private var scale1: CGFloat = 0
    /// Animiert die 2. Aufgabe.
    @State private var scale2: CGFloat = 0
    var body: some View {
        VStack {
            Spacer()
            Text("Deine heutige Aufgabe:").fontWeight(.bold).font(.system(.title, design: .rounded)).multilineTextAlignment(.leading)
            Spacer()
            AufgabeDetail(aufgabenGeladen: aufgabenGeladen, Aufgabe: self.aufgabe1).onTapGesture {
                self.scale1 = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.scale2 = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.coreDataFunctions.aktuelleAufgabeAuswaehlen(aufgabe: self.aufgabe1)
                }
            }
            .scaleEffect(scale1)
            .animation(Animation.easeInOut(duration: 0.2))
            AufgabeDetail(aufgabenGeladen: aufgabenGeladen, Aufgabe: self.aufgabe2).onTapGesture {
                self.scale2 = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.scale1 = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.coreDataFunctions.aktuelleAufgabeAuswaehlen(aufgabe: self.aufgabe2)
                }
            }
            .scaleEffect(scale2)
            .animation(Animation.easeInOut(duration: 0.2))

            Spacer()
            }
        .background(Color(UIColor .systemGroupedBackground))
        .onAppear{
            self.scale1 = 1.05
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.scale1 = 0.95
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.scale1 = 1.02
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.scale1 = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.scale2 = 1.05
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.scale2 = 0.95
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.scale2 = 1.02
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.scale2 = 1
                }
            }
            self.coreDataFunctions.verbliebeneAufgabenAnzeigen() {
                result in
                    do {
                        let aufgabenArray = try result.get()
                        self.aufgabe1 = aufgabenArray[0] ?? Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "", text_detail: "", text_dp: "")
                        self.aufgabe2 = aufgabenArray[1] ?? Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "", text_detail: "", text_dp: "")
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
