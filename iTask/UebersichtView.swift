//
//  UebersichtView.swift
//  iTask
//
//  Created by Thomas on 28.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct VergangeneAufgabe {
    var aufgabe: String
    var erledigt: Bool
}

struct UebersichtView: View {
    var erfolgreicheAufgabeFolge: Int
    var erledigteAufgaben: Int
    var vergangeneAufgaben: [VergangeneAufgabe]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Erfolgreich erledigte")
                            Text("Aufgabe in Folge")
                        }
                        Spacer()
                        Text(String(erfolgreicheAufgabeFolge))
                        Image(systemName: "checkmark").foregroundColor(.blue)
                    }
                    HStack {
                        Text("Insgesamt erledigte")
                        Spacer()
                        Text(String(erledigteAufgaben))
                        Image(systemName: "checkmark").foregroundColor(.blue)
                    }
                }
                Section (header: Text("Aufgaben Statistik")){
                    VStack (alignment: .leading){
                        Additives_diagramm(erledigteA: 10, nichtErledigteA: 5, aufgeschobeneA: 1)
                            .frame(minHeight: 24, maxHeight: 24)
                        HStack {
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(.green)
                            Text("Erledigt").font(.footnote)
                            Spacer()
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(.red)
                            Text("nicht Erledigt").font(.footnote)
                            Spacer()
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(.yellow)
                            Text("Aufgeschoben").font(.footnote)
                            
                        }
                        .padding(.horizontal)
                    }
                }
                Section (header: Text("Vergangene Aufgaben")){
                    ForEach(vergangeneAufgaben , id: \VergangeneAufgabe.aufgabe) { vergangeneAufgabe in
                        
                        HStack {
                            Text(vergangeneAufgabe.aufgabe)
                            Spacer()
                            Image(systemName: vergangeneAufgabe.erledigt ? "checkmark.circle" : "xmark.circle")
                        }
                        
                    }
                    
                }
                Section (header: Text("Vergangene Aufgaben")){
                
                    PieChartRow(data: [8,23,54], backgroundColor: Color(UIColor.lightGray), accentColor: .green)
                        .foregroundColor(.red)
                        .frame(width: 100, height: 100)
                        .padding()
                }
            }
            .navigationBarTitle(Text("Übersicht"))
        }
    }
}

struct UebersichtView_Previews: PreviewProvider {
    static var previews: some View {
        UebersichtView(erfolgreicheAufgabeFolge: 5, erledigteAufgaben: 2, vergangeneAufgaben: [VergangeneAufgabe(aufgabe: "Laufen", erledigt: true),VergangeneAufgabe(aufgabe: "Treppen", erledigt: false)])
    }
}
