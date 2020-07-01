//
//  ContentView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 27.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    
    @EnvironmentObject var firebaseFunctions: FirebaseFunctions
    @EnvironmentObject var coreDataFunctions: CoreDataFunctions
    @EnvironmentObject var globalFunctions: GlobalFunctions
    
    @ViewBuilder
    var body: some View {
        
        if globalFunctions.isLoading {
            Loading().onAppear{
                self.globalFunctions.load()
            }
        }
            
        else if self.firebaseFunctions.registered {
            TabView {
                
                HeuteView(curUser: self.coreDataFunctions.curUser)
                    .tabItem {
                        VStack {
                            Image(systemName: "flag")
                            Text("Heute")
                        }
                }.tag(0)
                
                
                UebersichtView(
                    erfolgreicheAufgabeFolge: 7,
                    erledigteAufgaben: 4,
                    vergangeneAufgaben: [VergangeneAufgabe(aufgabe: "Ich bin unterwegs", erledigt: true)])
                    .tabItem {
                        VStack {
                            Image(systemName: "square.split.1x2")
                            Text("Übersicht")
                        }
                }.tag(1)
                
                
                FreundeView(
                    fb: firebaseFunctions,
                    cd: coreDataFunctions)
                    .tabItem {
                        VStack {
                            Image(systemName: "rectangle.stack.person.crop.fill")
                            Text("Freunde")
                        }
                }.tag(2)
                
                
                EinstellungenView()
                    .tabItem {
                        VStack {
                            Image(systemName: "slider.horizontal.3")
                            Text("Einstellungen")
                        }
                }.tag(3)
                
                
            }.onAppear{
                //self.coreDataFunctions.getCurUserFromFirebase()
               self.coreDataFunctions.getUsersFromFirebase()
               // self.coreDataFunctions.getAufgabenFromFirebase()
                
                
            }
        } else {
            Register().onDisappear{}
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
