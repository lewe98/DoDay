//
//  AktuellSecondView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 29.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct AktuellSecondView: View {
    
    @EnvironmentObject var coreDataFunctions: CoreDataFunctions
    
    @State var aufgabe = Aufgabe(
        abgelehnt: 0,
        aufgeschoben: 0,
        ausgespielt: 0,
        autor: "",
        erledigt: 0,
        id: 0,
        kategorie: "",
        text: "loading...",
        text_detail: "loading...",
        text_dp: "loading...")
    
    @State var aufgabenGeladen = false
    
    var body: some View {
            VStack {
                Spacer()
                Text("Du hast dir für heute folgende Aufgabe ausgesucht.").lineLimit(nil)
                    .multilineTextAlignment(.center).font(.headline).padding(20)
                AufgabeDetail(
                    aufgabenGeladen: aufgabenGeladen,
                    Aufgabe: aufgabe).onAppear {
                        self.aufgabe = self.coreDataFunctions.getAufgabeByID(
                            id: self.coreDataFunctions.curUser.aufgabe)!
                        self.aufgabenGeladen = true
                }
                
                Text("Konntest du die Aufgabe erfolgreich erledigen?")
                    .font(.footnote)
                    .padding()
            
                Button(action: {
                    self.coreDataFunctions.aufgabeErledigt()
                }) {
                    Text("Ja")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .background(Color(.tertiarySystemBackground))
                .border(Color.gray, width: 0.2)
                .padding(.top)
                
                Button(action: {
                    self.coreDataFunctions.aufgabeAblehnen()
                }) {
                    Text("Nein")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .foregroundColor(.red)
                .background(Color(.tertiarySystemBackground))
                .border(Color.gray, width: 0.2)
                .padding(.top)
                
                Button(action: {
                    self.coreDataFunctions.aufgabeAufschieben()
                }) {
                    Text("Ich verschiebe die Aufgabe")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .background(Color(.tertiarySystemBackground))
                .border(Color.gray, width: 0.2)
                .padding(.top)
                Spacer()
            }
            .background(Color(UIColor .systemGroupedBackground))
    }
}

/*

struct AktuellSecondView_Previews: PreviewProvider {
    static var previews: some View {
        AktuellSecondView(aufgabenGeladen: true, Aufgabe: "Mache das!")
    }
}
*/
