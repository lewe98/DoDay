//
//  Register.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 08.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct Register: View {
    
    @EnvironmentObject var firebaseFunctions: FirebaseFunctions
    @EnvironmentObject var einstellungen: Einstellungen
    
    @State private var nutzername: String = ""
    
    @State var datenschutzAkzeptiert: Bool = false
    @State var showingDatenschutz = false
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    
                    Section(header: Text("WIE SOLLEN WIR DICH NENNEN?")) {
                        TextField("Dein Nutzername", text: $nutzername)
                    }
                    
                    
                    HStack {
                        Image(systemName: datenschutzAkzeptiert ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                self.datenschutzAkzeptiert.toggle()
                        }
                        Text("Datenschutzerklärung akzeptieren")
                            .onTapGesture {
                                self.showingDatenschutz.toggle()
                        }
                        .sheet(isPresented: $showingDatenschutz) {
                            DatenschutzWebview()
                        }
                    }
                
                    
                    if datenschutzAkzeptiert && nutzername.count > 1 {
                        Section() {
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.firebaseFunctions.registerUser(nutzername: self.nutzername)
                                }) {
                                    Text("Jetzt registrieren")
                                        .foregroundColor(.green)
                                }
                                Spacer()
                            }
                        }
                    }
                    
                    
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .navigationBarTitle(Text("Willkommen!"))
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
