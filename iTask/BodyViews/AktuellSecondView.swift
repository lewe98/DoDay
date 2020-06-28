//
//  AktuellSecondView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 29.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct AktuellSecondView: View {
    var Aufgabe: String
    var body: some View {
            VStack {
                Spacer()
                Text("Du hast dir für heute folgende Aufgabe ausgesucht.").lineLimit(nil)
                    .multilineTextAlignment(.center).font(.headline).padding(20)
                AufgabeDetail(Aufgabe: Aufgabe)
                Text("Konntest du die Aufgabe erfolgreich erledigen?")
                    .font(.footnote)
                    .padding()
            
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Ja")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .background(Color(.tertiarySystemBackground))
                .border(Color.gray, width: 0.2)
                .padding(.top)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Nein")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .foregroundColor(.red)
                .background(Color(.tertiarySystemBackground))
                .border(Color.gray, width: 0.2)
                .padding(.top)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Ich brauche mehr Zeit")
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

struct AktuellSecondView_Previews: PreviewProvider {
    static var previews: some View {
        AktuellSecondView(Aufgabe: "Mache das!")
    }
}
