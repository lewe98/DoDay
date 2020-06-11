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
    @State var showingFreundeHerausfordern = false
    @State var showingFreundeHinzufuegen = false
    
    //MARK: Muss irgendwo anders definiert werden
    let currUser = User(abgelehnt: [3, 5], aktueller_streak: 5, anzahl_benachrichtigungen: 1, aufgabe: 17, aufgeschoben: [8], erledigt: [9, 28], freunde: ["fkr93k", "fsl93"], freundes_id: "kd93k", id: "fkd90wlödlf9", letztes_erledigt_datum: Date(), vorname: "Thomas", nachname: "Raab")
    
    let currAufgabe = Aufgabe(abgelehnt: 22, aufgeschoben: 23, ausgespielt: 24, autor: "iTask", erledigt: 8, id: 12, kategorie: "Social", text: "Sprich mit einer fremden Person", text_detail: "Fördere deine Sozialkompetenz, indem du mit einer Person sprichst, mit der du vorher noch nie gesprochen hast. Zum Beispiel dein Postbote, jemand beim Einkaufen usw.", text_dp: "Spricht mit einer fremden Person")
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("DEIN FREUNDESCODE")) {
                    HStack {
                        // TODO: Korrekte Variable dynamisch ausgeben
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
                            self.showingFreundeHinzufuegen.toggle()
                        }) {
                            Text("Freunde hinzufügen")
                        }
                        .sheet(isPresented: $showingFreundeHinzufuegen) {
                        FreundeHinzufuegenView()
                        }
                        Spacer()
                    }
                }
                
                Section(header: HStack {Text("FREUNDE"); Spacer(); Text("ERLEDIGTE AUFGABEN")}) {
                     // TODO: Liste dynamisch fuellen mit for Schleife
                    List {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(currUser.vorname + " " + currUser.nachname)
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
                                Text(currUser.vorname  + " " + currUser.nachname)
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
                            self.freundeHerausfordern()
                        }) {
                            Text("Fordere deine Freunde heraus")
                        }
                        Spacer()
                    }
                }
            }
        .navigationBarTitle(Text("Freunde"))
        }
    }
    
    func kopiereId() -> Void {
        // TODO: Richtige Variable kopieren
        UIPasteboard.general.string = self.currUser.id
        withAnimation(.linear(duration: 0.25), {
            self.kopierenText = "erfolgreich kopiert!"
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.linear(duration: 0.25), {
                self.kopierenText = "Kopieren"
            })
        }
    }
    
    func freundeHerausfordern() -> Void {
        showingFreundeHerausfordern.toggle()
        let teilenText = "Könntest du meine heutige DoDay-Aufgabe schaffen?\n\"\(currAufgabe.text)\""
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [teilenText], applicationActivities: nil)

        // Entfernte Teilen-Buttons
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]

        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}

struct FreundeView_Previews: PreviewProvider {
    static var previews: some View {
        FreundeView()
    }
}
