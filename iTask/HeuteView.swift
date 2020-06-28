//
//  HeuteView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI
// hey

struct HeuteView: View {
    init() {
        // UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        // UINavigationBar.appearance().titleTextAttributes = [.strokeColor: UIColor .systemGroupedBackground]
     
        UINavigationBar.appearance().backgroundColor =  UIColor.systemGroupedBackground
        
    }
    var aufgabeInArbeit = true
    var body: some View {
        switch aufgabeInArbeit {
        case true:
            return AnyView(
                NavigationView {
                   AktuellFirstView(Aufgabe1: "Sprich mit einer dir fremden Person", Aufgabe2: "Gehe 10.000 Schritte Zu Fuß")
                    .navigationBarTitle(Text("Aktuell")).navigationBarHidden(false)
                }
            )
        case false:
            return
                AnyView(
                NavigationView {
                   AktuellSecondView(Aufgabe: "Sprich mit einer dir fremden Person")
                    .navigationBarTitle(Text("Aktuell"))
                }
                    .background(Color(UIColor .systemGroupedBackground))
            )
            
        }
    }
}

struct HeuteView_Previews: PreviewProvider {
    static var previews: some View {
        HeuteView()
    }
}
