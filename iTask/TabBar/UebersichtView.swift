//
//  UebersichtView.swift
//  DoDay
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
    let alleAufgaben: [Aufgabe]
    let zuletztBearbeitetErledigt: Bool
    @State var erledigte = [Aufgabe]()
    @State var abgelehnt = [Aufgabe]()
    
    init(user: User, zuletztBearbeitet: Aufgabe, zuletztBearbeitetErledigt: Bool, alleAufgaben: [Aufgabe]) {
        self.user = user
        self.zuletztBearbeitet = zuletztBearbeitet
        self.alleAufgaben = alleAufgaben
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
                    }
                }
                
                
                if user.erledigt.count > 0 {
                Section (header: Text("Zuletzt erledigt")){
                        HStack {
                            Text(self.zuletztBearbeitet.text)
                            Spacer()
                            Image(systemName: zuletztBearbeitetErledigt ? "checkmark.circle" : "xmark.circle")
                        }
                    }
                }
                
                
                if user.erledigt.count > 0 {
                    Section (header: Text("Erledigte Aufgaben")){
                        ForEach(self.erledigte, id: \.self) { aufgabe in
                            HStack {
                                Text(aufgabe.text)
                                Spacer()
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }.onAppear{
                        self.erledigte = self.alleAufgaben.filter{ aufgabe -> Bool in
                            if self.user.erledigt.contains(aufgabe.id){
                                return true
                            } else {
                                return false
                            }
                        }
                    }
                }
                
                
                if user.abgelehnt.count > 0{
                    Section (header: Text("Abgelehnte Aufgaben")){
                        ForEach(self.abgelehnt, id: \.self) { aufgabe in
                            HStack {
                                Text(aufgabe.text)
                                Spacer()
                                Image(systemName: "xmark.circle")
                            }
                        }
                    }.onAppear{
                        self.abgelehnt = self.alleAufgaben.filter{ aufgabe -> Bool in
                            if self.user.abgelehnt.contains(aufgabe.id){
                                return true
                            } else {
                                return false
                            }
                        }
                    }
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
