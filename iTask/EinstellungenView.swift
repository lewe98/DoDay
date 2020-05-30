//
//  EinstellungenView.swift
//  iTask
//
//  Created by Thomas on 28.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct EinstellungenView: View {
    @State private var erinnerungEigeneAktiviert = false
    @State private var erinnerungFreundeAbgeschlossenAktiviert = false
    @State private var erinnerungFreundeProblemeAktiviert = false
    
    var body: some View {
        VStack(alignment: .leading,spacing: 12) {
            
            Text("Einstellungen").fontWeight(.heavy).font(.largeTitle)
            .padding(.horizontal)
            .padding(.top,92)
            
            Form {
                Section {
                    HStack {
                        // TODO: Hier Erinnerung wirklich togglen
                        Toggle(isOn: $erinnerungEigeneAktiviert) {
                            VStack(alignment: .leading) {
                                Text("Meine Erinnerung")
                                    .font(.headline)
                                Text("Täglich um 8:00 Uhr")
                                    .font(.callout)
                                    .foregroundColor(Color.gray)
                            }
                        }
                    }
                }
            }
            .frame(height: 100.0)
            .padding(.bottom, 15)
            
            
            Form {
                Section(header: Text("INFORMIERE MICH, WENN FREUNDE...")) {
                    List {
                      Toggle(isOn: $erinnerungFreundeAbgeschlossenAktiviert) {
                            Text("Aufgaben abgeschlossen haben")
                            .font(.headline)
                        }
                        Toggle(isOn: $erinnerungFreundeProblemeAktiviert) {
                            Text("Probleme mit Aufgaben haben")
                            .font(.headline)
                        }
                    }
                }
            }
            .frame(height: 150.0)

            Form {
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            // TODO: Funktion einfuegen
                            print("Aufgabe einreichen tapped")
                        }) {
                            Text("Aufgabe einreichen")
                        }
                        Spacer()
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            // TODO: Funktion einfuegen
                            print("Statistik zurücksetzen tapped")
                        }) {
                            Text("Statistik zurücksetzen")
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                }
            }
            .frame(height: 200.0)
            
            Spacer()
            
            HStack{
                Button(action: {
                    // TODO: Funktion einfuegen
                    print("Imoressum tapped")
                }) {
                    Text("Impressum")
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {
                    // TODO: Funktion einfuegen
                    print("Datenschutz tapped")
                }) {
                    Text("Datenschutz")
                        .foregroundColor(.gray)
                }
            }.padding(.horizontal)
            Spacer()
        }
        .background(Color(UIColor.secondarySystemBackground))
            .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct EinstellungenView_Previews: PreviewProvider {
    static var previews: some View {
        EinstellungenView()
    }
}
