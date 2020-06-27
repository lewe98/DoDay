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
    @State var showingImpressum = false
    @State var showingDatenschutz = false
    @State var showingAufgabeEinreichen = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("NEUE AUFGABEN")) {
                        Toggle(isOn: $einstellungen.erinnerungEigeneAktiviert) {
                            Text("Täglich eine Erinnerung erhalten")
                    }
                        DatePicker("Uhrzeit wählen", selection: $einstellungen.erinnerungZeitDate, displayedComponents: .hourAndMinute)
                }

                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showingAufgabeEinreichen.toggle()
                        }) {
                            Text("Eigene Aufgabe einreichen")
                        }
                        .sheet(isPresented: $showingAufgabeEinreichen) {
                        AufgabeEinreichenView()
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
                    Text("Impressum")
                        .foregroundColor(.gray)
                        .padding(.leading)
                        .onTapGesture {
                        self.showingImpressum.toggle()
                        }
                        .sheet(isPresented: $showingImpressum) {
                            ImpressumWebview()
                        }
                    Spacer()
                    Text("Datenschutz")
                        .foregroundColor(.gray)
                        .padding(.trailing)
                        .onTapGesture {
                            self.showingDatenschutz.toggle()
                        }
                        .sheet(isPresented: $showingDatenschutz) {
                            DatenschutzWebview()
                        }
                }.listRowBackground(Color(UIColor.secondarySystemBackground))
            }
            .navigationBarTitle(Text("Einstellungen"))
        }
    }
}

struct EinstellungenView_Previews: PreviewProvider {
    static var previews: some View {
        EinstellungenView()
    }
}
