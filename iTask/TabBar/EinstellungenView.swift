//
//  EinstellungenView.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct EinstellungenView: View {
    @ObservedObject var einstellungen = Einstellungen()
    @State var showingImpressum = false
    @State var showingDatenschutz = false
    @State var showingAufgabeEinreichen = false
    @State var aufgabeEingereicht = false
    
    @Environment(\.presentationMode) var presentation
       
    @State private var showingAlert = false
    
    let firebaseFunctions: FirebaseFunctions
    let coreDataFunctions: CoreDataFunctions
    
    init(fb: FirebaseFunctions, cd: CoreDataFunctions) {
        self.firebaseFunctions = fb
        self.coreDataFunctions = cd
    }

    var body: some View {
        NavigationView {
            Form {
                
                
                Section(header: Text("NEUE AUFGABEN")) {
                        Toggle(isOn: $einstellungen.erinnerungEigeneAktiviert) {
                            Text("Täglich eine Erinnerung erhalten")
                    }
                        DatePicker("Uhrzeit wählen",
                                   selection: $einstellungen.erinnerungZeitDate,
                                   displayedComponents: .hourAndMinute)
                }

                
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showingAufgabeEinreichen.toggle()
                        }) {
                            Text("Eigene Aufgabe einreichen")
                        }
                        .sheet(isPresented: $showingAufgabeEinreichen, onDismiss: {}) {
                            AufgabeEinreichenView(fb: self.firebaseFunctions, cd: self.coreDataFunctions)
                        }
                        Spacer()
                    }
                }
                
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showingAlert = true
                        }) {
                            Text("Fortschritt zurücksetzen")
                                .foregroundColor(.red)
                        }.alert(isPresented: self.$showingAlert) {
                            Alert(title: Text("Gesamten Fortschritt zurücksetzen?"),
                                  message: Text("Dieser Vorgang kann nicht rückgängig gemacht werden."),
                                  primaryButton: .destructive(Text("Zurücksetzen")) {
                                    
                                    self.coreDataFunctions.curUser.abgelehnt = []
                                    self.coreDataFunctions.curUser.aufgeschoben = []
                                    self.coreDataFunctions.curUser.erledigt = []
                                    self.coreDataFunctions.curUser.aktueller_streak = 0
                                    
                                    var aufgabenIDs = [Int]()
                                    
                                    self.coreDataFunctions.allCDAufgaben.forEach{ elem in
                                        aufgabenIDs.append(elem.id)
                                    }
                                    
                                    self.coreDataFunctions.curUser.verbliebene_aufgaben = aufgabenIDs
                                    
                                    self.coreDataFunctions.updateCurUser() { result in
                                        do {
                                            let _ = try result.get()
                                            print("Statistiken zurückgesetzt.")
                                        } catch {
                                            print("Fehler beim Zurücksetzen der Statistiken.")
                                        }
                                        
                                    }
                                    
                                }, secondaryButton: .cancel(Text("Abbrechen"))
                            )
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
