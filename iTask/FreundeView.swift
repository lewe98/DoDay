//
//  FreundeView.swift
//  iTask
//
//  Created by Thomas on 28.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct FreundeView: View {
    @State var kopierenText = "Kopieren"
    //MARK: Muss irgendwo anders definiert werden
    let currUser = UserModel(id: "LgUZK2f", name: "Thomas Raab", aufgabe: 2, aktueller_streak: 3, letztes_erledigt_datum: "2020-05-29", anzahl_benachrichtigungen: 0)
    
    let currAufgabe = AufgabeModel(id: 1, text: "Sprich mit einer fremden Person", text_dp: "Spricht mit einer fremden Person", detailtext: "Fördere deine Sozialkompetenz, indem du mit einer Person sprichst, mit der du vorher noch nie gesprochen hast. Zum Beispiel dein Postbote, jemand beim Einkaufen usw.", kategorie: "Social", autor: "admin", ausgespielt: 1, erledigt: 0, abgelehnt: 0, aufgeschoben: 0)
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section(header: Text("DEIN FREUNDESCODE")) {
                        HStack {
                            // TODO: Korrekte Variable ausgeben
                            Text(currUser.id)
                            Spacer()
                            Button(action: {
                                self.kopiereId()
                            }) {
                                Text(kopierenText)
                            }
                        }
                        HStack{
                            Spacer()
                            Button(action: {
                                print("Freunde hinzufügen tapped")
                            }) {
                                Text("Freunde hinzufügen")
                            }
                            Spacer()
                        }
                    }
                    
                    Section(header: HStack {Text("FREUNDE"); Spacer(); Text("ERLEDIGTE AUFGABEN")}) {
                         // TODO: Liste dynamisch fuellen mit for Schleife
                        List {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(currUser.name)
                                    Text(currAufgabe.text_dp)
                                        .font(.callout)
                                        .foregroundColor(Color.gray)
                                }
                                Spacer()
                                // TODO: Dynamisch machen
                                Text("6")
                            }
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(currUser.name)
                                    Text(currAufgabe.text_dp)
                                        .font(.callout)
                                        .foregroundColor(Color.gray)
                                }
                                Spacer()
                                Text("22")
                            }
                        }
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            Button(action: {
                                // TODO: Funktionalitaet... Freunden eine Aufgabe schicken
                                print("Fordere deine Freunde raus tapped")
                            }) {
                                Text("Fordere deine Freunde heraus")
                            }
                            Spacer()
                        }
                    }
                }
        }.background(Color(UIColor.secondarySystemBackground))
        .navigationBarTitle(Text("Freunde"))
        }
    }
    
    func kopiereId() -> Void {
        // TODO: Richtige Variable kopieren
        UIPasteboard.general.string = self.currUser.id
        self.kopierenText = "erfolgreich kopiert!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.kopierenText = "Kopieren"
        }
    }
}

struct FreundeView_Previews: PreviewProvider {
    static var previews: some View {
        FreundeView()
    }
}
