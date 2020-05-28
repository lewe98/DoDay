//
//  ContentView.swift
//  iTask
//
//  Created by Julian Hermanspahn on 27.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HeuteView()
            .tabItem {
                VStack {
                    Image(systemName: "flag")
                    Text("Heute")
                }
            }.tag(0)
            
            UebersichtView()
            .tabItem {
                VStack {
                    Image(systemName: "square.split.1x2")
                    Text("Übersicht")
                }
            }.tag(1)
            
            FreundeView()
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
