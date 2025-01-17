//
//  FreundeHinzufuegenView.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 09.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct FreundeHinzufuegenView: View {
    
    let globalFunctions: GlobalFunctions
    
    @Environment(\.presentationMode) var presentation
    
    @State private var showingAlert = false
    
    @State private var alertTitle = ""
    
    @State private var alertText = ""
    
    @State private var freundesCode: String = ""
    
    init(gf: GlobalFunctions) {
        self.globalFunctions = gf
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    
                    
                    Section(header: Text("FREUNDESCODE EINGEBEN")) {
                        TextField("Freundescode", text: $freundesCode)
                    }
                    
                    
                    Section() {
                        HStack {
                            Spacer()
                            Button(action: {
                                if self.freundesCode.trimmingCharacters(in: .whitespacesAndNewlines) == self.globalFunctions.coreDataFunctions.curUser.freundes_id {
                                    self.alertTitle = "Ungültige ID."
                                    self.alertText = "Die eigene ID kann nicht hinzugefügt werden."
                                    self.showingAlert = true
                                } else if self.globalFunctions.coreDataFunctions.curUser.freunde.contains(self.freundesCode.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                    self.alertTitle = "Ungültige ID."
                                    self.alertText = "ID ist bereits in deiner Freundesliste."
                                    self.showingAlert = true
                                } else if self.freundesCode.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                                    self.alertTitle = "Leeres Feld."
                                    self.alertText = "Bitte gib einen Freundescode ein."
                                    self.showingAlert = true
                                } else if !self.globalFunctions.coreDataFunctions.curUser.freunde.contains(self.freundesCode.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                    self.globalFunctions.callAddFriend(freundID: self.freundesCode.trimmingCharacters(in: .whitespacesAndNewlines))
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.presentation.dismiss()
                                    }
                                }
                            }) {
                                Text("Abschicken")
                                    .foregroundColor(.green)
                            }.alert(isPresented: $showingAlert){
                                Alert(title: Text(self.alertTitle),
                                      message: Text(self.alertText),
                                      dismissButton: .default(Text("OK"))
                                )
                            }
                            Spacer()
                        }
                    }
                    
                    
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .navigationBarTitle(Text("Freund hinzufügen"))
        }
    }
}

/*
struct FreundeHinzufuegenView_Previews: PreviewProvider {
    static var previews: some View {
        FreundeHinzufuegenView()
    }
}
*/
