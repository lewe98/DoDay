//
//  HeuteView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct HeuteView: View {
    @EnvironmentObject var coreDataFunctions: CoreDataFunctions
    @State var aufgabenGeladen = false
    let aufgabenArray: [Aufgabe]
    var aufgabe1 = ""
    var aufgabe2 = ""
    

    var aufgabeInArbeit = true
    let user: User
    let greeting: String
    
    init(curUser: User, aufgabenArray: [Aufgabe]) {
        // UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        // UINavigationBar.appearance().titleTextAttributes = [.strokeColor: UIColor .systemGroupedBackground]
        user = curUser
        greeting = "Hey, " + user.nutzername + "!"
        self.aufgabenArray = aufgabenArray
        UINavigationBar.appearance().backgroundColor =  UIColor.systemGroupedBackground
        aufgabeInArbeit = true
        if self.aufgabenArray.count > 1 {
            self.aufgabe1 = self.aufgabenArray[0].text
            self.aufgabe2 = self.aufgabenArray[0].text
        }
    }
    
    
    
    
    var body: some View {
        switch aufgabeInArbeit {
            
        case true:
            return AnyView(
                NavigationView {
                   AktuellFirstView(aufgabenGeladen: self.aufgabenGeladen,
                   Aufgabe1: self.aufgabe1,
                   Aufgabe2: self.aufgabe2)
                    .navigationBarTitle(Text(greeting))
                    .navigationBarHidden(false)
                }
            ).onAppear{
                self.reload()
            }
            
        case false:
            return
                AnyView(
                NavigationView {
                    AktuellSecondView(aufgabenGeladen: aufgabenGeladen, Aufgabe: "Sprich mit einer dir fremden Person")
                    .navigationBarTitle(Text("Aktuell"))
                }.background(Color(UIColor .systemGroupedBackground))
            ).onAppear{
                self.reload()
            }
            
        }
    }
    func reload(){
            self.aufgabenGeladen = true
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
                verbliebene_aufgaben: []),
                aufgabenArray: [])
    }
}
