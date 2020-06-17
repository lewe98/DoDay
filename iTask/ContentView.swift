//
//  ContentView.swift
//  iTask
//
//  Created by Julian Hermanspahn on 27.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI
import Foundation

extension Bool {
    mutating func toggle() {
        self = !self
    }
}
var testtext = "nope"
public var registered: Bool = false

struct ContentView: View {
    

    // @ObservedObject var coreDataFunctions = CoreDataFunctions()
    @ObservedObject var firebaseFunctions = FirebaseFunctions()
    @ObservedObject var einstellungen = Einstellungen()
    @EnvironmentObject var functions: FirebaseFunctions
    @State var istRegistered = FirebaseFunctions().registered
    @State var deletedCoreDataEntries: Bool = false
    @State var testtextinnen = testtext
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    @Environment (\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Aufgaben.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Aufgaben.text,
                ascending: true
            )
        ]
    ) var tasksCoreData: FetchedResults<Aufgaben>
    
    
    @ViewBuilder
    var body: some View {
            // MARK: - Diese 5 Texte sollten sich eigentlich auch live updaten - das passiert aber nicht. Sie sind gleichzeitig buttons, um die verschiedenen registered Variablen zu togglen
            // MARK: - registered Variable in diesem ContentView. Togglen mit Tap auf diesen Text funktioniert auch
        Text("istRegistered ist: \(self.istRegistered.description)")
            .onTapGesture {
                registered.toggle()
        }
        // MARK: - registered Variable in den firebaseFunctions.
        Text("registered firebasefunctions ist: \(firebaseFunctions.registered.description)")
            .onTapGesture {
                self.firebaseFunctions.registered.toggle()
        }
        // MARK: - registered Variable in den firebaseFunctions, aber auf deine Art, Samuel, also mit EnvironmentObject "functions"
        Text("registered functions ist: \(functions.registered.description)")
            .onTapGesture {
                self.functions.registered.toggle()
        }
        // MARK: - registered Variable aus Einstellungen.swift. Arbeitet eigentlich mit UserDefaults...
        Text("registered einstellungen ist: \(einstellungen.userIstRegistriert.description)")
            .onTapGesture {
                Einstellungen().userIstRegistriert.toggle()
        }
        // MARK: - Hier noch mal als print, weil ich dachte: Vielleicht ist ja der View nur nicht neu gerendert. Aber auch der Print funktioniert nicht (die Variable ist hier einfach nie geupdatet).
        Text("FUNCTIONS REGISTERED AUSGEBEN")
            .onTapGesture {
                print("HIER IST DIE AUSGABE VON FUNCTIONS.REGISTERED: \(self.functions.registered)")
        }
        if self.functions.registered {
            TabView {
                HeuteView()
                    .tabItem {
                        VStack {
                            Image(systemName: "flag")
                            Text("Heute")
                        }
                }.tag(0)
                
                UebersichtView(erfolgreicheAufgabeFolge: 7, erledigteAufgaben: 4, vergangeneAufgaben: [VergangeneAufgabe(aufgabe: "Ich bin unterwegs", erledigt: true)])
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
            .onAppear {
                self.firebaseFunctions.getCurrUser(id: self.uuid!)
            }
        } else {
            Register()
        }
    }
    
    
    /*
     var body: some View {
         
         VStack{
             NavigationView{
                 // Daten aus Firebase
                 List(firebaseFunctions.aufgaben) { (aufgabe: Aufgabe) in
                     Text(aufgabe.text)
                 }
                 .navigationBarTitle("Firebase")
             }
             
             NavigationView{
                 // Daten aus Core Data
                 List(self.tasksCoreData.map {
                     Aufgabe.initFromDatabase(aufgabe: $0)
                 }, id: \Aufgabe.id) { aufgabe in
                     Text(aufgabe.text)
                 }
                 .navigationBarTitle("Core Data")
             }
             
         }
         .onAppear() {
             self.reload()
         }
     }
     */
    
    func toggleRegistered() {
        registered.toggle()
        testtext = "jo"
        print("Ja es wurde getoggelt und ist jetzt auf \(self.istRegistered.description) und testtext: \(self.testtextinnen)")
    }
    
    func reload() {
        /*
        self.retrieveData.fetchlastEditDate { (datum, error) in
            if let datum = datum {
                if datum.aufgaben_zuletzt_bearbeitet as Date > Date() {
                    */
        
                    self.firebaseFunctions.fetchTasks { (aufgabeModel, error) in
                        if let aufgabe = aufgabeModel {
                            
                            if(self.deletedCoreDataEntries == false){
                                self.deleteAllEntries()
                                self.deletedCoreDataEntries = true
                            }
                            
                            self.insertIntoCoreData(aufgabe: aufgabe)
                            

                            
                        } else if let error = error{
                            print("Error: \(String(describing: error))")
                        }
                    }
                    
                //}
                
            //}
        //}
    }
    
    
    
    public func deleteAllEntries() {
        self.tasksCoreData.forEach { aufgabe in
            self.managedObjectContext.delete(aufgabe)
        }
        try! self.managedObjectContext.save()
    }
    
    
    
    public func insertIntoCoreData(aufgabe: Aufgabe) {
        let entity = Aufgaben(context: self.managedObjectContext)
        
        entity.abgelehnt = Int16(aufgabe.abgelehnt)
        entity.aufgeschoben = Int16(aufgabe.aufgeschoben)
        entity.ausgespielt = Int16(aufgabe.ausgespielt)
        entity.autor = aufgabe.autor
        entity.erledigt = Int16(aufgabe.erledigt)
        entity.id = Int16(aufgabe.id)
        entity.kategorie = aufgabe.kategorie
        entity.text = aufgabe.text
        entity.text_detail = aufgabe.text_detail
        entity.text_dp = aufgabe.text_dp
        
        try! self.managedObjectContext.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
