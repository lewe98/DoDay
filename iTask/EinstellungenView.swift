//
//  EinstellungenView.swift
//  iTask
//
//  Created by Thomas on 28.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct EinstellungenView: View {
    @ObservedObject var einstellungen = Einstellungen()
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section(header: Text("NEUE AUFGABEN")) {
                            Toggle(isOn: $einstellungen.erinnerungEigeneAktiviert) {
                                    Text("Tägliche Erinnerung erhalten")
                        }
                            DatePicker("Uhrzeit wählen", selection: $einstellungen.erinnerungZeitDate, displayedComponents: .hourAndMinute)
                    }
                
                    Section(header: Text("AKTIVITÄTEN DEINER FREUNDE")) {
                        // TODO: Serverseitig einstellen
                          Toggle(isOn: $einstellungen.erinnerungFreundeAktiviert) {
                                Text("Updates deiner Freunde erhalten")
                        }
                    }

                    Section {
                        HStack {
                            Spacer()
                            Button(action: {
                                // TODO: Funktion einfuegen
                                print("Aufgabe einreichen tapped")
                            }) {
                                Text("Eigene Aufgabe einreichen")
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
                    
                    HStack{
                        Button(action: {
                            // TODO: Funktion einfuegen
                            print("Impressum tapped")
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
                    }.listRowBackground(Color(UIColor.secondarySystemBackground))
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .navigationBarTitle(Text("Einstellungen"))
        }
    }
}

struct EinstellungenView_Previews: PreviewProvider {
    static var previews: some View {
        EinstellungenView()
    }
}
