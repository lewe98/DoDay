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
                
                // self.deleteAllData(entity: "CurUser")
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
        
        print("INSERT CURRENT USER: ", newCurrentUser)
        
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
            
            print("GET CURRENT USER: ", curUserResult)
        } catch {
            print("Failed")
        }
    }
    
    
    
    func getUsersFromFirebase() {
        self.firebaseFunctions.fetchUsers { (userFB, error) in
            if let user = userFB {
                
                // self.deleteAllData(entity: "Users")
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
                
                var user: User = User(
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
                
                user.abgelehnt = data.value(forKey: "abgelehnt") as! [Int]
                user.aktueller_streak = data.value(forKey: "aktueller_streak") as! Int
                user.anzahl_benachrichtigungen = data.value(forKey: "anzahl_benachrichtigungen") as! Int
                user.aufgabe = data.value(forKey: "aufgabe") as! Int
                user.aufgeschoben = data.value(forKey: "aufgeschoben") as! [Int]
                user.erledigt = data.value(forKey: "erledigt") as! [Int]
                user.freunde = data.value(forKey: "freunde") as! [String]
                user.freundes_id = data.value(forKey: "freundes_id") as! String
                user.id = data.value(forKey: "id") as! String
                user.letztes_erledigt_datum = data.value(forKey: "letztes_erledigt_datum") as! Date
                user.verbliebene_aufgaben = data.value(forKey: "verbliebene_aufgaben") as! [Int]
                user.nutzername = data.value(forKey: "nutzername") as! String
                
                self.allCDUsers.append(user)
            }
            
            print("GET ALL USERS: ", allCDUsers)
            
        } catch {
            print("Failed")
        }
    }
    
    
    
    func getAufgabenFromFirebase() {
        self.firebaseFunctions.fetchTasks { (aufgabeModel, error) in
            if let aufgabe = aufgabeModel {
                
                // self.deleteAllData(entity: "Aufgaben")
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
        let getAufgaben = NSFetchRequest<NSFetchRequestResult>(entityName: "Aufgaben")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        getAufgaben.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(getAufgaben)
            for data in result as! [NSManagedObject] {
                
                var aufgabe: Aufgabe = Aufgabe(
                abgelehnt: 0,
                aufgeschoben: 0,
                ausgespielt: 0,
                autor: "DoDay",
                erledigt: 0,
                id: 0,
                kategorie: "",
                text: "",
                text_detail: "",
                text_dp: "")
                
                aufgabe.abgelehnt = data.value(forKey: "abgelehnt") as! Int
                aufgabe.aufgeschoben = data.value(forKey: "aufgeschoben") as! Int
                aufgabe.ausgespielt = data.value(forKey: "ausgespielt") as! Int
                aufgabe.autor = data.value(forKey: "autor") as! String
                aufgabe.erledigt = data.value(forKey: "erledigt") as! Int
                aufgabe.id = data.value(forKey: "id") as! Int
                aufgabe.kategorie = data.value(forKey: "kategorie") as! String
                aufgabe.text = data.value(forKey: "text") as! String
                aufgabe.text_detail = data.value(forKey: "text_detail") as! String
                aufgabe.text_dp = data.value(forKey: "text_dp") as! String
                
                self.allCDAufgaben.append(aufgabe)
            }
            
            print("GET ALL AUFGABEN: ", allCDAufgaben)
            
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
    
    
    
    func deleteAllData(entity: String) {
        //, completionHandler: @escaping (Bool?, Error?) -> ()) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
            //completionHandler(true, nil)
        } catch let error as NSError {
            //completionHandler(nil, error)
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

}
