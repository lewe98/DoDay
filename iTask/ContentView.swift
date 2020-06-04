//
//  ContentView.swift
//  iTask
//
//  Created by Julian Hermanspahn on 27.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // @ObservedObject var coreDataFunctions = CoreDataFunctions()
    @ObservedObject var firebaseFunctions = FirebaseFunctions()
    @State var deletedCoreDataEntries: Bool = false



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
    
    
    
    var body: some View {
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
