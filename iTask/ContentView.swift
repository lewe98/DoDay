//
//  ContentView.swift
//  iTask
//
//  Created by Julian Hermanspahn on 27.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    @Environment (\.managedObjectContext) var managedObjectContext
    
    @State var deletedCoreDataTasks: Bool = false
    @State var deletedCoreDataUsers: Bool = false
    @State var deletedCoreDataCurUser: Bool = false
    
    @State var isLoading: Bool = true
    
    
    //MARK: - TODO: Müssen außerhalb einsehbar sein
    @State var cdAufgaben = [Aufgabe]()
    @State var cdUsers = [User]()
    @State var cdCurUser = [User]()
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    @FetchRequest(
        entity: Aufgaben.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Aufgaben.text,
                ascending: true
            )
        ]
    ) var tasksCoreData: FetchedResults<Aufgaben>
    
    @FetchRequest(
        entity: Users.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Users.id,
                ascending: true
            )
        ]
    ) var usersCoreData: FetchedResults<Users>
    
    @FetchRequest(
        entity: CurUser.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \CurUser.id,
                ascending: true
            )
        ]
    ) var curUserCoreData: FetchedResults<CurUser>
    
    @EnvironmentObject var firebaseFunctions: FirebaseFunctions
    //@EnvironmentObject var coreDataFunctions: CoreDataFunctions
    
    @ViewBuilder
    var body: some View {
        if self.isLoading {
            Loading().onAppear{
                self.reload()
                
            }
        }
        else if self.firebaseFunctions.registered {
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
        } else {
            Register()
        }
    }
    
    func reload() {
        
        self.isLoading = true
        
        self.firebaseFunctions.fetchTasks { (aufgabeModel, error) in
            if let aufgabe = aufgabeModel {
                
                if(self.deletedCoreDataTasks == false){
                    self.deleteOldTasks()
                    self.deletedCoreDataTasks = true
                }
                
                self.insertTasksIntoCoreData(aufgabe: aufgabe)
                
            } else if let error = error{
                print("Error: \(String(describing: error))")
            }
        }
        
        self.firebaseFunctions.fetchUsers { (userFB, error) in
            if let user = userFB {
                
                if(self.deletedCoreDataUsers == false){
                    self.deleteOldUsers()
                    self.deletedCoreDataUsers = true
                }
                
                self.insertUsersIntoCoreData(user: user)
                
            } else if let error = error{
                print("Error: \(String(describing: error))")
            }
        }
        
        self.firebaseFunctions.getCurrUser { (u, err) in
            if let user = u {
                
                if (self.deletedCoreDataCurUser == false){
                    self.deleteOldCurUser()
                    self.deletedCoreDataCurUser = true
                }
                
                self.insertCurUserIntoCoreData(user: user)
                
            } else if let error = err{
                print("Error: \(String(describing: error))")
            }
        }
        
        tasksCoreData.forEach { aufgabe in
            cdAufgaben.append(Aufgabe.initAufgabeFromDatabase(aufgabe: aufgabe))
            print("AUFGABE AUS CORE DATA: ", Aufgabe.initAufgabeFromDatabase(aufgabe: aufgabe))
        }
        
        usersCoreData.forEach { user in
            cdUsers.append(User.initUserFromDatabase(user: user))
            print("USER AUS CORE DATA: ", User.initUserFromDatabase(user: user))
        }
        
        curUserCoreData.forEach { user in
            cdCurUser.append(User.initCurUserFromDatabase(user: user))
            print("CURRENT USER AUS CORE DATA: ", User.initCurUserFromDatabase(user: user))
        }
        
        print(cdAufgaben.count, cdUsers.count, cdCurUser.count)
        
        self.isLoading = false
    }
    
    func deleteOldTasks() {
        self.tasksCoreData.forEach { aufgabe in
            self.managedObjectContext.delete(aufgabe)
        }
        try? self.managedObjectContext.save()
    }
    
    func deleteOldUsers() {
        self.usersCoreData.forEach { user in
            self.managedObjectContext.delete(user)
        }
        try? self.managedObjectContext.save()
    }
    
    func deleteOldCurUser() {
        self.curUserCoreData.forEach { user in
            self.managedObjectContext.delete(user)
        }
        try? self.managedObjectContext.save()
    }
    
    func insertCurUserIntoCoreData(user: User) {
        let entity = CurUser(context: self.managedObjectContext)
        
        entity.abgelehnt = user.abgelehnt as NSObject
        entity.aktueller_streak = Int16(user.aktueller_streak)
        entity.anzahl_benachrichtigungen = Int16(user.anzahl_benachrichtigungen)
        entity.aufgabe = Int16(user.aufgabe)
        entity.aufgeschoben = user.aufgeschoben as NSObject
        entity.erledigt = user.erledigt as NSObject
        entity.freunde = user.freunde as NSObject
        entity.freundes_id = user.freundes_id
        entity.id = user.id
        entity.letztes_erledigt_datum = user.letztes_erledigt_datum
        entity.verbliebene_aufgaben = user.verbliebene_aufgaben as NSObject
        entity.vorname = user.vorname
        
        try? self.managedObjectContext.save()
    }
    
    func insertUsersIntoCoreData(user: User) {
        let entity = Users(context: self.managedObjectContext)
        
        entity.abgelehnt = user.abgelehnt as NSObject
        entity.aktueller_streak = Int16(user.aktueller_streak)
        entity.anzahl_benachrichtigungen = Int16(user.anzahl_benachrichtigungen)
        entity.aufgabe = Int16(user.aufgabe)
        entity.aufgeschoben = user.aufgeschoben as NSObject
        entity.erledigt = user.erledigt as NSObject
        entity.freunde = user.freunde as NSObject
        entity.freundes_id = user.freundes_id
        entity.id = user.id
        entity.letztes_erledigt_datum = user.letztes_erledigt_datum
        entity.verbliebene_aufgaben = user.verbliebene_aufgaben as NSObject
        entity.vorname = user.vorname
        
        try? self.managedObjectContext.save()
    }
    
    func insertTasksIntoCoreData(aufgabe: Aufgabe) {
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
        
        try? self.managedObjectContext.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
