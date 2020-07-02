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
    
    // MARK: - VARIABLES
    /// Firebase
    @EnvironmentObject var firebaseFunctions: FirebaseFunctions
    
    /// Core Data
    @EnvironmentObject var coreDataFunctions: CoreDataFunctions
    
    /// global Functions
    @EnvironmentObject var globalFunctions: GlobalFunctions
    
    
    
    // MARK: - BODY
    @ViewBuilder
    var body: some View {
        
        if globalFunctions.isLoading {
            Loading().onAppear {
                self.globalFunctions.load()
            }
        }
            
        else if self.firebaseFunctions.registered {
            
            TabView {
                HeuteView(curUser: self.coreDataFunctions.curUser, aufgabenArray: self.coreDataFunctions.allCDAufgaben)
                    .tabItem {
                        VStack {
                            Image(systemName: "flag")
                            Text("Heute")
                        }
                }.tag(0)
                
                
                UebersichtView(
                    user: self.coreDataFunctions.curUser,
                    zuletztBearbeitet: self.coreDataFunctions.getZuletztErledigt(),
                    zuletztBearbeitetErledigt: self.coreDataFunctions.checkIfErledigt(
                        id: self.coreDataFunctions.getZuletztErledigt().id))
                    
                    .tabItem {
                        VStack {
                            Image(systemName: "square.split.1x2")
                            Text("Übersicht")
                        }
                }.tag(1)
                
                
                FreundeView(
                    fb: firebaseFunctions,
                    cd: coreDataFunctions,
                    gf: globalFunctions)
                    .tabItem {
                        VStack {
                            Image(systemName: "rectangle.stack.person.crop.fill")
                            Text("Freunde")
                        }
                }.tag(2)
                
                
                EinstellungenView(fb: self.firebaseFunctions)
                    .tabItem {
                        VStack {
                            Image(systemName: "slider.horizontal.3")
                            Text("Einstellungen")
                        }
                }.tag(3)
                
                
            }
        } else {
            Register()
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
