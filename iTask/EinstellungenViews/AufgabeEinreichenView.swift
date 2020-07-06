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
    
    init(fb: FirebaseFunctions) {
        self.firebaseFunctions = fb
    }
    
    @State private var text: String = ""
    @State private var text_detail: String = ""
    @State private var text_dp: String = ""
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    
                    Section(header: Text("DEINE AUFGABE")) {
                        TextField("Kurztext", text: $text)
                        TextField("Detaillierter Text", text: $text_detail)
                        TextField("Text in dritter Person", text: $text_dp)
                    }
                
                    Section() {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.presentation.dismiss()
                                self.firebaseFunctions.addNewAufgabe(
                                    text: self.text,
                                    text_detail: self.text_detail,
                                    text_dp: self.text_dp,
                                    kategorie: "Eingereicht von User.")
                            }) {
                                Text("Abschicken")
                                    .foregroundColor(.green)
                            }
                            Spacer()
                        }
                    }
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
