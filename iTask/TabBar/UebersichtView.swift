//
//  UebersichtView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct VergangeneAufgabe {
    var aufgabe: String
    var erledigt: Bool
}

struct UebersichtView: View {
    let user: User
    let zuletztBearbeitet: Aufgabe
    let zuletztBearbeitetErledigt: Bool
    
    let a: Double
    let b: Double
    let c: Double
    
    init(user: User, zuletztBearbeitet: Aufgabe, zuletztBearbeitetErledigt: Bool) {
        self.user = user
        self.zuletztBearbeitet = zuletztBearbeitet
        self.zuletztBearbeitetErledigt = zuletztBearbeitetErledigt
        
        self.a = Double(self.user.erledigt.count)
        self.b = Double(self.user.abgelehnt.count)
        self.c = Double(self.user.aufgeschoben.count)
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
                            erledigteA: self.a,
                            nichtErledigteA: self.b,
                            aufgeschobeneA: self.c)
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
                
                
                Section (header: Text("Zuletzt erledigt:")){
                        HStack {
                            Text(self.zuletztBearbeitet.text)
                            Spacer()
                            Image(systemName: zuletztBearbeitetErledigt ? "checkmark.circle" : "xmark.circle")
                        }
                        
                    
                }
                
                
                Section (header: Text("Statistik")) {
                    PieChartRow(
                        data: [self.a, self.b, self.c],
                        backgroundColor: Color(UIColor.lightGray),
                        accentColor: .green)
                        .foregroundColor(.red)
                        .frame(width: 100, height: 100)
                        .padding()
                }
            
            }.navigationBarTitle(Text("Übersicht"))
        }
    }
}

struct UebersichtView_Previews: PreviewProvider {
    static var previews: some View {
        UebersichtView(user: User(abgelehnt: [], aktueller_streak: 0, anzahl_benachrichtigungen: 0, aufgabe: 0, aufgeschoben: [], erledigt: [], freunde: [], freundes_id: "test", id: "test", letztes_erledigt_datum: Date(), nutzername: "test", verbliebene_aufgaben: []), zuletztBearbeitet: Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "DoDay", erledigt: 0, id: 0, kategorie: "test", text: "test", text_detail: "test", text_dp: "test"), zuletztBearbeitetErledigt: true)
    }
}
