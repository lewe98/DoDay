//
//  CoreDataFunctions.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 04.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataFunctions: ObservableObject {
    
    
    let context: NSManagedObjectContext
    let firebaseFunctions: FirebaseFunctions
    
    
    let curUserEntity: NSEntityDescription
    let userEntity: NSEntityDescription
    let aufgabeEntity: NSEntityDescription
    
    
    let newCurrentUser: NSManagedObject
    let newUsers: NSManagedObject
    let newAufgaben: NSManagedObject
    
    
    @Published var allCDUsers = [User]()
    @Published var allCDAufgaben = [Aufgabe]()
    @Published var curUserResult: User = User(
        abgelehnt: [],
        aktueller_streak: 0,
        anzahl_benachrichtigungen: 0,
        aufgabe: 0, aufgeschoben: [],
        erledigt: [],
        freunde: [],
        freundes_id: "",
        id: "",
        letztes_erledigt_datum: Date(),
        verbliebene_aufgaben: [],
        nutzername: "")
    
    
    
    init(firebase: FirebaseFunctions, context: NSManagedObjectContext) {
        self.firebaseFunctions = firebase
        self.context = context
        
        self.curUserEntity = NSEntityDescription.entity(forEntityName: "CurUser", in: context)!
        self.userEntity = NSEntityDescription.entity(forEntityName: "Users", in: context)!
        self.aufgabeEntity = NSEntityDescription.entity(forEntityName: "Aufgaben", in: context)!
        
        self.newCurrentUser = NSManagedObject(entity: curUserEntity, insertInto: context)
        self.newUsers = NSManagedObject(entity: userEntity, insertInto: context)
        self.newAufgaben = NSManagedObject(entity: aufgabeEntity, insertInto: context)
    }
    
    
    
    func getCurUserFromFirebase() {
        self.firebaseFunctions.getCurrUser { (u, err) in
            if let user = u {
                
                self.insertNewCurrentUserIntoCoreData(user: user)
                self.fetchCDCurUser()
                
            } else if let error = err {
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    
    
    func insertNewCurrentUserIntoCoreData(user: User) {
        
        newCurrentUser.setValue(user.abgelehnt, forKey: "abgelehnt")
        newCurrentUser.setValue(user.aktueller_streak, forKey: "aktueller_streak")
        newCurrentUser.setValue(user.anzahl_benachrichtigungen, forKey: "anzahl_benachrichtigungen")
        newCurrentUser.setValue(user.aufgabe, forKey: "aufgabe")
        newCurrentUser.setValue(user.aufgeschoben, forKey: "aufgeschoben")
        newCurrentUser.setValue(user.erledigt, forKey: "erledigt")
        newCurrentUser.setValue(user.freunde, forKey: "freunde")
        newCurrentUser.setValue(user.freundes_id, forKey: "freundes_id")
        newCurrentUser.setValue(user.id, forKey: "id")
        newCurrentUser.setValue(user.letztes_erledigt_datum, forKey: "letztes_erledigt_datum")
        newCurrentUser.setValue(user.verbliebene_aufgaben, forKey: "verbliebene_aufgaben")
        newCurrentUser.setValue(user.nutzername, forKey: "nutzername")
        
        saveCoreData()
    }
    
    
    
    func fetchCDCurUser(){
        let getCurUser = NSFetchRequest<NSFetchRequestResult>(entityName: "CurUser")
        
        //request.predicate = NSPredicate(format: "age = %@", "12")
        getCurUser.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(getCurUser)
            for data in result as! [NSManagedObject] {
                curUserResult.abgelehnt = data.value(forKey: "abgelehnt") as! [Int]
                curUserResult.aktueller_streak = data.value(forKey: "aktueller_streak") as! Int
                curUserResult.anzahl_benachrichtigungen = data.value(forKey: "anzahl_benachrichtigungen") as! Int
                curUserResult.aufgabe = data.value(forKey: "aufgabe") as! Int
                curUserResult.aufgeschoben = data.value(forKey: "aufgeschoben") as! [Int]
                curUserResult.erledigt = data.value(forKey: "erledigt") as! [Int]
                curUserResult.freunde = data.value(forKey: "freunde") as! [String]
                curUserResult.freundes_id = data.value(forKey: "freundes_id") as! String
                curUserResult.id = data.value(forKey: "id") as! String
                curUserResult.letztes_erledigt_datum = data.value(forKey: "letztes_erledigt_datum") as! Date
                curUserResult.verbliebene_aufgaben = data.value(forKey: "verbliebene_aufgaben") as! [Int]
                curUserResult.nutzername = data.value(forKey: "nutzername") as! String
            }
            
            print("ICH HEULE: ", curUserResult)
        } catch {
            print("Failed")
        }
    }
    
    
    
    func getUsersFromFirebase() {
        self.firebaseFunctions.fetchUsers { (userFB, error) in
            if let user = userFB {
                
                self.insertUserIntoCoreData(user: user)
                self.fetchCDUsers()
                
            } else if let error = error{
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    
    
    func insertUserIntoCoreData(user: User) {
        
        newUsers.setValue(user.abgelehnt, forKey: "abgelehnt")
        newUsers.setValue(user.aktueller_streak, forKey: "aktueller_streak")
        newUsers.setValue(user.anzahl_benachrichtigungen, forKey: "anzahl_benachrichtigungen")
        newUsers.setValue(user.aufgabe, forKey: "aufgabe")
        newUsers.setValue(user.aufgeschoben, forKey: "aufgeschoben")
        newUsers.setValue(user.erledigt, forKey: "erledigt")
        newUsers.setValue(user.freunde, forKey: "freunde")
        newUsers.setValue(user.freundes_id, forKey: "freundes_id")
        newUsers.setValue(user.id, forKey: "id")
        newUsers.setValue(user.letztes_erledigt_datum, forKey: "letztes_erledigt_datum")
        newUsers.setValue(user.verbliebene_aufgaben, forKey: "verbliebene_aufgaben")
        newUsers.setValue(user.nutzername, forKey: "nutzername")
        
        saveCoreData()
    }
    
    
    
    func fetchCDUsers() {
        let getUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        getUsers.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(getUsers)
            for data in result as! [NSManagedObject] {
                print("USERS AUS CORE DATA: ", data.value(forKey: "nutzername") as! String)
            }
            
        } catch {
            print("Failed")
        }
    }
    
    
    
    func getAufgabenFromFirebase() {
        self.firebaseFunctions.fetchTasks { (aufgabeModel, error) in
            if let aufgabe = aufgabeModel {
                
                self.insertAufgabeIntoCoreData(aufgabe: aufgabe)
                self.fetchCDAufgaben()
                
            } else if let error = error{
                print("Error: \(String(describing: error))")
            }
            
        }
    }
    
    
    
    func insertAufgabeIntoCoreData(aufgabe: Aufgabe) {
        
        newAufgaben.setValue(aufgabe.abgelehnt, forKey: "abgelehnt")
        newAufgaben.setValue(aufgabe.aufgeschoben, forKey: "aufgeschoben")
        newAufgaben.setValue(aufgabe.ausgespielt, forKey: "ausgespielt")
        newAufgaben.setValue(aufgabe.autor, forKey: "autor")
        newAufgaben.setValue(aufgabe.erledigt, forKey: "erledigt")
        newAufgaben.setValue(aufgabe.id, forKey: "id")
        newAufgaben.setValue(aufgabe.kategorie, forKey: "kategorie")
        newAufgaben.setValue(aufgabe.text, forKey: "text")
        newAufgaben.setValue(aufgabe.text_detail, forKey: "text_detail")
        newAufgaben.setValue(aufgabe.text_dp, forKey: "text_dp")
        
        saveCoreData()
    }
    
    
    
    func fetchCDAufgaben(){
        let getUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "Aufgaben")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        getUsers.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(getUsers)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "text") as! String)
            }
            
        } catch {
            print("Failed")
        }
    }
    
    
    
    func saveCoreData(){
        do {
            try context.save()
        } catch {
            print("Failed saving.")
        }
    }
    
    
    
}
