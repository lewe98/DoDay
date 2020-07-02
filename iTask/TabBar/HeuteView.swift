//
//  HeuteView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct HeuteView: View {
    
    var aufgabeInArbeit = true
    let user: User
    let greeting: String
    
    init(curUser: User) {
        // UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        // UINavigationBar.appearance().titleTextAttributes = [.strokeColor: UIColor .systemGroupedBackground]
        user = curUser
        greeting = "Hey, " + user.nutzername + "!"
        UINavigationBar.appearance().backgroundColor =  UIColor.systemGroupedBackground
        
    }
    
    
    
    
    var body: some View {
        switch aufgabeInArbeit {
            
        case true:
            return AnyView(
                NavigationView {
                   AktuellFirstView(
                    Aufgabe1: "Sprich mit einer dir fremden Person",
                    Aufgabe2: "Gehe 10.000 Schritte Zu Fuß")
                    .navigationBarTitle(Text(greeting))
                    .navigationBarHidden(false)
                }
            )
            
        case false:
            return
                AnyView(
                NavigationView {
                   AktuellSecondView(Aufgabe: "Sprich mit einer dir fremden Person")
                    .navigationBarTitle(Text("Aktuell"))
                }.background(Color(UIColor .systemGroupedBackground))
            )
            
        }
    }
}

struct HeuteView_Previews: PreviewProvider {
    static var previews: some View {
        HeuteView(
            curUser: User(
                abgelehnt: [],
                aktueller_streak: 0,
                anzahl_benachrichtigungen: 0,
                aufgabe: 0,
                aufgeschoben: [],
                erledigt: [],
                freunde: [],
                freundes_id: "abc123",
                id: "id82",
                letztes_erledigt_datum: Date(),
                nutzername: "PreviewName",
                verbliebene_aufgaben: []))
    }
}
