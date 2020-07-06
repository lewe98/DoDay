//
//  UebersichtView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct VergangeneAufgabe {
    var aufgabe: String
    var erledigt: Bool
}

struct UebersichtView: View {
    let user: User
    let zuletztBearbeitet: Aufgabe
    let letzteAufgaben: [Aufgabe]
    let zuletztBearbeitetErledigt: Bool
    
    init(user: User, zuletztBearbeitet: Aufgabe, zuletztBearbeitetErledigt: Bool, letzteAufgaben: [Aufgabe]) {
        self.user = user
        self.zuletztBearbeitet = zuletztBearbeitet
        self.letzteAufgaben = letzteAufgaben
        self.zuletztBearbeitetErledigt = zuletztBearbeitetErledigt
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Deine Streak:")
                        }
                        Spacer()
                        Text(String(self.user.aktueller_streak))
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                    HStack {
                        Text("Insgesamt erledigt:")
                        Spacer()
                        Text(String(self.user.erledigt.count))
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                
                
                Section (header: Text("Statistik")) {
                    VStack (alignment: .leading){
                        
                        Additives_diagramm(
                            erledigteA: self.user.erledigt.count,
                            nichtErledigteA: self.user.abgelehnt.count,
                            aufgeschobeneA: self.user.aufgeschoben.count)
                            
                            .frame(minHeight: 24, maxHeight: 24)
                        
                        HStack {
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(.green)
                            Text("erledigt").font(.footnote)
                            
                            Spacer()
                            
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(.red)
                            
                            Text("nicht erledigt").font(.footnote)
                            
                            Spacer()
                            
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(.yellow)
                            
                            Text("aufgeschoben").font(.footnote)
                            
                        }.padding(.horizontal)
                    }
                }
                
                
                Section (header: Text("Zuletzt erledigt")){
                        HStack {
                            Text(self.zuletztBearbeitet.text)
                            Spacer()
                            Image(systemName: zuletztBearbeitetErledigt ? "checkmark.circle" : "xmark.circle")
                        }
                        
                    
                }
                
                Section (header: Text("Aufgaben Verlauf")){
                    Text("Aufgabe")
                    /*
                    ForEach(0 ..< self.letzteAufgaben.count, id: \.self) {
                        Text(self.letzteAufgaben[$0])
                    
                        HStack {
                            Text(self.zuletztBearbeitet.text)
                            Spacer()
                            Image(systemName: zuletztBearbeitetErledigt ? "checkmark.circle" : "xmark.circle")
                        }
                    }
                    */
                }
            
            }.navigationBarTitle(Text("Übersicht"))
        }
    }
}

/*
struct UebersichtView_Previews: PreviewProvider {
    static var previews: some View {
        UebersichtView(user: User(abgelehnt: [], aktueller_streak: 0, anzahl_benachrichtigungen: 0, aufgabe: 0, aufgeschoben: [], erledigt: [], freunde: [], freundes_id: "test", id: "test", letztes_erledigt_datum: Date(), nutzername: "test", verbliebene_aufgaben: []), zuletztBearbeitet: Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "DoDay", erledigt: 0, id: 0, kategorie: "test", text: "test", text_detail: "test", text_dp: "test"), zuletztBearbeitetErledigt: true)
    }
}
 */
