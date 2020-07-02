//
//  HeuteView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct HeuteView: View {
    let curUser: User
    let aufgabenArray: [Aufgabe]
    
    @EnvironmentObject var coreDataFunctions: CoreDataFunctions
    @State var aufgabenGeladen = false
    @State var aufgabe1: Aufgabe = Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "loading...", text_detail: "loading...", text_dp: "")
    @State var aufgabe2: Aufgabe = Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "loading...", text_detail: "loading...", text_dp: "")
    @State var curAufgabe: Aufgabe = Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "loading...", text_detail: "loading...", text_dp: "")
    @State var aufgabeInArbeit = 0
    
    
    init(curUser: User, aufgabenArray: [Aufgabe]) {
        self.curUser = curUser
        self.aufgabenArray = aufgabenArray
        // UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        // UINavigationBar.appearance().titleTextAttributes = [.strokeColor: UIColor .systemGroupedBackground]
        UINavigationBar.appearance().backgroundColor =  UIColor.systemGroupedBackground
    }
    
    var body: some View {
        switch aufgabeInArbeit {
            
        case 1:
            return AnyView(
                NavigationView {
                   AktuellFirstView(aufgabenGeladen: self.aufgabenGeladen,
                                    Aufgabe1: self.aufgabe1,
                   Aufgabe2: self.aufgabe2)
                    .navigationBarTitle(Text("Hey " + self.coreDataFunctions.curUser.nutzername + "!" ))
                    .navigationBarHidden(false)
                }
            )
            .onAppear{
                self.reload()
            }
            .onTapGesture {
                self.setAufgabeInArbeit()
            }
            
        case 2:
            return
                AnyView(
                NavigationView {
                    AktuellSecondView(aufgabenGeladen: aufgabenGeladen, Aufgabe: curAufgabe)
                    .navigationBarTitle(Text("Aktuell"))
                }.background(Color(UIColor .systemGroupedBackground))
            ).onAppear{
                self.reload()
            }.onTapGesture {
                self.aufgabeInArbeit = 1
            }
        case 3:
            return
                AnyView(
                NavigationView {
                    Text("Nicht genügend Aufgaben in der Datenbank!")
                    .navigationBarTitle(Text("Aktuell"))
                }.background(Color(UIColor .systemGroupedBackground))
            ).onAppear{
                self.reload()
            }.onTapGesture {
                
            }
        default:
            return
                AnyView(
                    ActivityIndicator()
                ).onAppear{
                    self.SetAufgabeForView()
            }.onTapGesture {
            }
        }
    }
    func reload(){
            self.aufgabenGeladen = true
    }
    
    func SetAufgabeForView() {
        print("SetAufgabenView: ", self.curUser)
        let aufgabeID = self.curUser.aufgabe
        if (aufgabeID >= 0) {
            self.aufgabeInArbeit = 2
            self.curAufgabe = self.coreDataFunctions.getAufgabeByID(id: aufgabeID) ?? Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "loading...", text_detail: "loading...", text_dp: "")
        } else {
            self.aufgabeInArbeit = 1
            if self.aufgabenArray.count > 0 {
                let maxRage = self.aufgabenArray.count - 1
                self.aufgabe1 = self.aufgabenArray[Int.random(in: 0..<maxRage)]
                self.aufgabe2 = self.aufgabenArray[Int.random(in: 0..<maxRage)]
            }
        }
        print("SetAufgabenView: ", self.aufgabeInArbeit)

    }
    
    func setAufgabeInArbeit() {
        self.aufgabeInArbeit = 2
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
