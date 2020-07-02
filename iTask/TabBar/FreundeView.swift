//
//  FreundeView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct Freund: Hashable {
    var nutzername: String
    var erledigt: Int
    var text_dp: String
}


struct FreundeView: View {
    @State var kopierenText = "Kopieren"
    @State var showingFreundeHerausfordern = false
    @State var showingFreundeHinzufuegen = false
    @State var freundesListe: [Freund] = []
    
    
    let firebaseFunctions: FirebaseFunctions
    let coreDataFunctions: CoreDataFunctions
    let globalFunctions: GlobalFunctions
    
    init(fb: FirebaseFunctions, cd: CoreDataFunctions, gf: GlobalFunctions) {
        self.firebaseFunctions = fb
        self.coreDataFunctions = cd
        self.globalFunctions = gf
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("DEIN FREUNDESCODE")) {
                    HStack {
                        Text(coreDataFunctions.curUser.freundes_id)
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
                            FreundeHinzufuegenView(gf: self.globalFunctions)
                            .environmentObject(self.firebaseFunctions)
                            /*.onDisappear(ContentView.reload { error in
                            if let error = error{
                                print(error)
                            })*/
                        }
                        Spacer()
                    }
                }
                
                Section(header: HStack {Text("FREUNDE"); Spacer(); Text("ERLEDIGTE AUFGABEN")}) {

                    List(self.freundesListe, id: \.self) {
                        freund in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(freund.nutzername)
                                Text(freund.text_dp)
                                    .font(.callout)
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                            Text(String(freund.erledigt))
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            //self.freundeHerausfordern()
                            print("freunde herausfordern...")
                        }) {
                            Text("Fordere deine Freunde heraus")
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text("Freunde"))
            //.onAppear{self.updateFreundesListe()}
        }
    }
    /*
    func updateFreundesListe() {
        print("\n\n\n\n curUser.count ist: \(curUser.count) bzw. der curUser: \n \(curUser)\n\n\n")
        if curUser.count > 0 {
            self.freundesListe = []
            curUser[0].freunde.forEach {freund in // alle Freunde durchgehen (freundes_id)
                allUsers.forEach { user in // User rausziehen
                    if user.freundes_id == freund {
                        alleAufgaben.forEach { aufgabe in // Aufgaben rausziehen
                            if user.aufgabe == aufgabe.id {
                                self.freundesListe.append(Freund(nutzername: user.nutzername, erledigt: user.erledigt.count, text_dp: aufgabe.text_dp))
                            }
                        }
                        
                    }
                }
            }
        } else {
            self.freundesListe = []
            }
    }
    */
    func kopiereId() -> Void {
        // TODO: Richtige Variable kopieren
        UIPasteboard.general.string = self.coreDataFunctions.curUser.freundes_id
        withAnimation(.linear(duration: 0.25), {
            self.kopierenText = "erfolgreich kopiert!"
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.linear(duration: 0.25), {
                self.kopierenText = "Kopieren"
            })
        }
    }
    /*
    func freundeHerausfordern() -> Void {
        showingFreundeHerausfordern.toggle()
        let teilenText = "Könntest du meine heutige DoDay-Aufgabe schaffen?\n\"\(curAufgabe.text)\""
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
 */
}

/*struct FreundeView_Previews: PreviewProvider {
    static var previews: some View {
        FreundeView(curUser: User(
        abgelehnt: [3, 5],
        aktueller_streak: 5,
        anzahl_benachrichtigungen: 1,
        aufgabe: 17,
        aufgeschoben: [8],
        erledigt: [9, 28],
        freunde: ["fkr93k", "fsl93"],
        freundes_id: "kd93k",
        id: "fkd90wlödlf9",
        letztes_erledigt_datum: Date(),
        verbliebene_aufgaben: [9, 1],
        nutzername: "Thomas"),
        alleAufgaben: [Aufgabe(abgelehnt: 22, aufgeschoben: 23, ausgespielt: 24, autor: "iTask", erledigt: 8, id: 12, kategorie: "Social", text: "Sprich mit einer fremden Person", text_detail: "Fördere deine Sozialkompetenz, indem du mit einer Person sprichst, mit der du vorher noch nie gesprochen hast. Zum Beispiel dein Postbote, jemand beim Einkaufen usw.", text_dp: "Spricht mit einer fremden Person")])
    }
}*/
