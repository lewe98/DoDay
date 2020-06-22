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
    @State public var cdAufgaben: [Aufgabe] = []
    @State public var cdUsers: [User] = []
    @State public var cdCurUser: [User] = []
    
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
    
    
    
    @ViewBuilder
    var body: some View {
        if self.isLoading {
            Loading().onAppear{
                self.reload { error in
                    if let error = error{
                        print(error)
                    }
                }
                
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
            Register().onDisappear{
                self.initCurUser()
                self.deletedCoreDataCurUser = false
            }
        }
    }
    
    func initCurUser(){
        self.firebaseFunctions.getCurrUser { (u, err) in
            if let user = u {
                
                self.insertCurUserIntoCoreData(user: user) { (nil, error) in
                    if let error = error{
                        print(error)
                    } else {
                        self.cdCurUser.append(user)
                        print("CURRENT USER AUS CORE DATA: ", user, self.cdCurUser.count)
                        
                    }
                }
                
            } else if let error = err{
                print("Error: \(String(describing: error))")
            }
            
        }
    }
    
    func reload(completionHandler: @escaping (Error?) -> ()) {
        
        self.isLoading = true
        
        self.firebaseFunctions.fetchTasks { (aufgabeModel, error) in
            if let aufgabe = aufgabeModel {
                if(self.deletedCoreDataTasks == false) {
                    self.deleteOldTasks { (error) in
                        if let error = error{
                            print(error)
                        }
                        self.deletedCoreDataTasks = true
                    }
                }
                self.insertTasksIntoCoreData(aufgabe: aufgabe) { (nil, error) in
                    if let error = error{
                        print(error)
                    } else {
                        self.cdAufgaben.append(aufgabe)
                        print("AUFGABE AUS CORE DATA: ", aufgabe, self.cdAufgaben.count)
                    }
                }
            } else if let error = error{
                print("Error: \(String(describing: error))")
            }
            
        }
        
     
        
        self.firebaseFunctions.fetchUsers { (userFB, error) in
            if let user = userFB {
                
                if(self.deletedCoreDataUsers == false){
                    self.deleteOldUsers { (error) in
                        if let error = error{
                            print(error)
                        } else{
                            self.deletedCoreDataUsers = true
                        }
                    }
                }
                
                self.insertUsersIntoCoreData(user: user) { (nil, error) in
                    if let error = error{
                        print(error)
                    } else {
                        self.cdUsers.append(user)
                        print("USER AUS CORE DATA: ", user, self.cdUsers.count)
                    }
                }
                
            } else if let error = error{
                print("Error: \(String(describing: error))")
            }
        }
        
        
        
        self.deletedCoreDataTasks = false
        self.deletedCoreDataUsers = false
        self.isLoading = false
        completionHandler(nil)
    }
    
    func deleteOldTasks(completionHandler: @escaping (Error?) -> ()) {
        self.cdAufgaben = []
        self.tasksCoreData.forEach { aufgabe in
            self.managedObjectContext.delete(aufgabe)
        }
        try? self.managedObjectContext.save()
        completionHandler(nil)
    }
    
    func deleteOldUsers(completionHandler: @escaping (Error?) -> ()) {
        self.cdUsers = []
        self.usersCoreData.forEach { user in
            self.managedObjectContext.delete(user)
        }
        try? self.managedObjectContext.save()
        completionHandler(nil)
    }
    
    
    
    func deleteOldCurUser(completionHandler: @escaping (Error?) -> ()) {
        self.cdCurUser = []
        self.curUserCoreData.forEach { user in
            self.managedObjectContext.delete(user)
        }
        try? self.managedObjectContext.save()
        completionHandler(nil)
    }
    
    
    
    func insertCurUserIntoCoreData(user: User, completionHandler: @escaping (CurUser?, Error?) -> ()) {
        self.deleteOldCurUser { (error) in
            if let error = error{
                print(error)
            }
        }
        
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
        completionHandler(entity, nil)
    }
    
    
    
    func insertUsersIntoCoreData(user: User, completionHandler: @escaping (Users?, Error?) -> ()) {
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
        completionHandler(entity, nil)
    }
    
    
    
    func insertTasksIntoCoreData(aufgabe: Aufgabe, completionHandler: @escaping (Aufgaben?, Error?) -> ()) {
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
        completionHandler(entity, nil)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
