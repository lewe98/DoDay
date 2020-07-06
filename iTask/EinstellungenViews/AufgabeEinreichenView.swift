//
//  AufgabeEinreichenView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 06.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI
import Combine

/// Eine View, die es dem Nutzer erlaubt, einen eigenen Aufgabenvorschlag einzureichen.
struct AufgabeEinreichenView: View {
    
    let firebaseFunctions: FirebaseFunctions
    @Environment(\.presentationMode) var presentation
    @State private var showingAlert = false
    @State private var aufgabeEingereicht = false
    
    init(fb: FirebaseFunctions) {
        self.firebaseFunctions = fb
    }
    
    @State private var text: String = ""
    @State private var text_detail: String = ""
    @State private var text_dp: String = ""
    let kategorie = ["Social","Fitness","Geist","Divers","Kultur","Haushalt"]
    @State private var kategoriePicker = 0
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    
                    Section(header: Text("DEINE AUFGABE")) {
                        TextField("Kurztext", text: $text)
                        TextField("Detaillierter Text", text: $text_detail)
                        TextField("Text in dritter Person", text: $text_dp)
                        Picker(selection: $kategoriePicker, label: Text("Kategorie")) {
                            ForEach(0 ..< kategorie.count, id: \.self) {
                                Text(self.kategorie[$0])
                            }
                        }
                    }
                
                    Section() {
                        HStack {
                            Spacer()
                            Button(action: {
                                if (self.text != "" && self.text_detail != "" && self.text_dp != "") {
                                     self.firebaseFunctions.addNewAufgabe(
                                     text: self.text,
                                     text_detail: self.text_detail,
                                     text_dp: self.text_dp,
                                     kategorie: self.kategorie[self.kategoriePicker])
                                    self.aufgabeEingereicht = true
                                } else {
                                    self.showingAlert = true
                                }
                            }) {
                                Text("Abschicken")
                                    .foregroundColor(.green)
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Leeres Feld!"), message: Text("Bitte alle Felder ausfüllen."), dismissButton: .default(Text("Okay")))
                            }
                            Spacer()
                        }
                    }
                }.alert(isPresented: $aufgabeEingereicht) {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.aufgabeEingereicht = false
                        self.presentation.dismiss()
                    }
                    return Alert(title: Text("Aufgabe gespeichert!"))
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .navigationBarTitle(Text("Aufgabe einreichen"))
        }
    }
}

/*
struct AufgabeEinreichenView_Previews: PreviewProvider {
    static var previews: some View {
        AufgabeEinreichenView()
    }
}
*/
