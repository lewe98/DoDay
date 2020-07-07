//
//  FreundeView.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct Freund: Hashable {
    var nutzername: String
    var freundes_id: String
    var erledigt: Int
    var text_dp: String
}


struct FreundeView: View {
    
    
    
    // MARK: - VARIABLES
    @State var kopierenText = "Kopieren"
    @State var showingFreundeHerausfordern = false
    @State var showingFreundeHinzufuegen = false
    @State var freundesListe: [Freund] = []
    
    @Environment(\.presentationMode) var presentation
    
    @State private var showingAlert = false
    
    let firebaseFunctions: FirebaseFunctions
    let coreDataFunctions: CoreDataFunctions
    @ObservedObject var globalFunctions: GlobalFunctions
    
    
    
    // MARK: - INITIALIZER
    init(fb: FirebaseFunctions, cd: CoreDataFunctions, gf: GlobalFunctions) {
        self.firebaseFunctions = fb
        self.coreDataFunctions = cd
        self.globalFunctions = gf
    }
    
    
    
    // MARK: - BODY
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
                        .sheet(isPresented: $showingFreundeHinzufuegen, onDismiss: {
                        self.globalFunctions.updateFreundesListe()
                        }) {
                            FreundeHinzufuegenView(gf: self.globalFunctions)
                            }
                        Spacer()
                    }
                }
                
                
                if coreDataFunctions.curUser.freunde.count > 0 {
                    Section(header: HStack {Text("FREUNDE"); Spacer(); Text("ERLEDIGTE AUFGABEN")}) {
                        List(self.globalFunctions.freundesListe, id: \.self) {
                            freund in
                            Button(action: {
                                self.showingAlert = true
                            }){
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(freund.nutzername)
                                        Text(freund.text_dp)
                                            .font(.callout)
                                            .foregroundColor(Color.gray)
                                    }.alert(isPresented: self.$showingAlert) {
                                        Alert(title: Text("Möchtest du diesen Freund entfernen?"),
                                              message: Text("Du kannst \(freund.nutzername) später erneut hinzufügen."),
                                              primaryButton: .destructive(Text("Löschen")) {
                                                
                                                var tempList = [String]()
                                                
                                                self.coreDataFunctions.curUser.freunde.forEach{ u in
                                                    if u != freund.freundes_id{
                                                        tempList.append(u)
                                                    }
                                                }
                                                
                                                self.coreDataFunctions.curUser.freunde = tempList
                                                
                                                self.coreDataFunctions.updateCurUser() { result in
                                                    do {
                                                        let _ = try result.get()
                                                        print("Freund entfernt.")
                                                    } catch {
                                                        print("Fehler beim Entfernen des Freundes.")
                                                    }
                                                    
                                                }
                                                
                                            }, secondaryButton: .cancel(Text("Abbrechen"))
                                        )
                                    }
                                    
                                    Spacer()
                                    Text(String(freund.erledigt))
                                }
                            }
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
                
                
            } .navigationBarTitle(Text("Freunde"))
            .onAppear {
                self.globalFunctions.updateFreundesListe()
                
            }
        }
    }
    
    
    
    // MARK: - FUNCTIONS
    /// Lorem Ipsum
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
    
    
    
    func freundeHerausfordern() -> Void {
        showingFreundeHerausfordern.toggle()
        
        if self.coreDataFunctions.curUser.aufgabe != 0 {
            let teilenText = "Könntest du meine heutige DoDay-Aufgabe schaffen?\n\"\(self.coreDataFunctions.getCurAufgabe().text)\""
            
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
 
/*

    struct FreundeView_Previews: PreviewProvider {
        static var previews: some View {
            FreundeView()
        }
    }
 */
}
