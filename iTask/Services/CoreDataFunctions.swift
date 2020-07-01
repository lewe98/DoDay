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
    
    /// Core Data
    let context: NSManagedObjectContext
    
    /// Firebase
    let firebaseFunctions: FirebaseFunctions
    
    /// die User-Tabelle in Core Data
    let userEntity: NSEntityDescription
    
    /// die Aufgaben-Tabelle in Core Data
    let aufgabeEntity: NSEntityDescription
    
    ///alle User, die in Core Data gespeichert sind
    @Published var allCDUsers = [User]()
    
    /// alle Aufgaben, die in Core Data gespeichert sind
    @Published var allCDAufgaben = [Aufgabe]()
    
    /// vordefiniertes User-Objekt, um den aktiven Nutzer zu speichern
    @Published var curUser: User = User(
        abgelehnt: [],
        aktueller_streak: 0,
        anzahl_benachrichtigungen: 0,
        aufgabe: 0,
        aufgeschoben: [],
        erledigt: [],
        freunde: [],
        freundes_id: "loading...",
        id: "loading...",
        letztes_erledigt_datum: Date(),
        nutzername: "loading...",
        verbliebene_aufgaben: [])
    
    /// Vendor-ID des Users
    let id: String
    
    
    init(firebase: FirebaseFunctions, context: NSManagedObjectContext, id: String) {
        
        self.firebaseFunctions = firebase
        self.context = context
        self.id = id
        
        
        self.allCDUsers = []
        self.allCDAufgaben = []
        
        
        self.userEntity = NSEntityDescription.entity(forEntityName: "Users", in: context)!
        self.aufgabeEntity = NSEntityDescription.entity(forEntityName: "Aufgaben", in: context)!
    }
    
    
    
    // MARK: - CURRENT USER
    /// Liest die Daten des angemeldeten Nutzers aus.
    func getCurUser() {
        self.curUser = self.allCDUsers.first(where: {$0.id == self.id})!
    }
    
    
    // MARK: - DELETE
    /// Löscht alle Objekte einer spezifizierten Entity in Core Data.
    ///
    /// - entity: Bezeichnung der Core Data Entity
    func delete(entity: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    // MARK: - USERS
    /// User aus Firebase werden in Core Data gespeichert
    func getUsersFromFirebase() {
        
        self.firebaseUserRequest { result in
            
            do {
                self.delete(entity: "Users")
                self.allCDUsers = try result.get()
                
                self.allCDUsers.forEach { user in
                    self.insertUserIntoCoreData(user: user)
                }
                
                self.getCurUser()
                
            }
            catch {
                self.fetchCDUsers()
            }
        }
    }
    
    
    
    /// User werden aus Firebase geladen und an den completion handler übergeben.
    func firebaseUserRequest(completionHandler: @escaping (Result<[User], Error>) -> Void) {
        
        self.firebaseFunctions.fetchUsers { (usersFB, error) in
            
            if let users = usersFB {
                completionHandler(.success(users))
                
            } else if let error = error{
                completionHandler(.failure(error))
                return
            }
        }
        return
    }
    
    
    
    /// Fügt einen Nutzer in Core Data hinzu.
    ///
    /// - user: user, der in Core Data gespeichert wird
    func insertUserIntoCoreData(user: User) {
        
        do {
            let newUser: NSManagedObject = NSManagedObject(entity: userEntity, insertInto: context)
            
            newUser.setValue(user.abgelehnt, forKey: "abgelehnt")
            newUser.setValue(user.aktueller_streak, forKey: "aktueller_streak")
            newUser.setValue(user.anzahl_benachrichtigungen, forKey: "anzahl_benachrichtigungen")
            newUser.setValue(user.aufgabe, forKey: "aufgabe")
            newUser.setValue(user.aufgeschoben, forKey: "aufgeschoben")
            newUser.setValue(user.erledigt, forKey: "erledigt")
            newUser.setValue(user.freunde, forKey: "freunde")
            newUser.setValue(user.freundes_id, forKey: "freundes_id")
            newUser.setValue(user.id, forKey: "id")
            newUser.setValue(user.letztes_erledigt_datum, forKey: "letztes_erledigt_datum")
            newUser.setValue(user.verbliebene_aufgaben, forKey: "verbliebene_aufgaben")
            newUser.setValue(user.nutzername, forKey: "nutzername")
            
            try context.save()
            
        } catch let error {
            print("Could not save user: ", error)
        }
    }
    
    
    
    /// Liest alle Nutzer aus Core Data aus.
    func fetchCDUsers() {
        
        let getUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        getUsers.returnsObjectsAsFaults = false
        
        do {
            self.allCDUsers = []
            let result = try context.fetch(getUsers)
            
            for data in result as! [NSManagedObject] {
                
                self.allCDUsers.append(
                    User(
                        abgelehnt: data.value(forKey: "abgelehnt") as! [Int],
                        aktueller_streak: data.value(forKey: "aktueller_streak") as! Int,
                        anzahl_benachrichtigungen: data.value(forKey: "anzahl_benachrichtigungen") as! Int,
                        aufgabe: data.value(forKey: "aufgabe") as! Int,
                        aufgeschoben: data.value(forKey: "aufgeschoben") as! [Int],
                        erledigt: data.value(forKey: "erledigt") as! [Int],
                        freunde: data.value(forKey: "freunde") as! [String],
                        freundes_id: data.value(forKey: "freundes_id") as! String,
                        id: data.value(forKey: "id") as! String,
                        letztes_erledigt_datum: data.value(forKey: "letztes_erledigt_datum") as! Date,
                        nutzername: data.value(forKey: "nutzername") as! String,
                        verbliebene_aufgaben: data.value(forKey: "verbliebene_aufgaben") as! [Int])
                )
            }
            
        } catch {
            print("Fehler beim Abrufen der User aus Core Data.")
        }
        
    }
    
    
    
    // MARK: - AUFGABEN
    /// Aufgaben aus Firebase werden in Core Data gespeichert
    func getAufgabenFromFirebase() {
        
        self.firebaseAufgabenRequest { result in
            
            do {
                self.delete(entity: "Aufgaben")
                self.allCDAufgaben = try result.get()
                
                self.allCDAufgaben.forEach { aufgabe in
                    self.insertAufgabeIntoCoreData(aufgabe: aufgabe)
                }
                
            }
            catch {
                self.fetchCDAufgaben()
            }
        }
    }
    
    
    
    /// Aufgaben werden aus Firebase geladen und an den completion handler übergeben.
    func firebaseAufgabenRequest(completionHandler: @escaping (Result<[Aufgabe], Error>) -> Void) {
        
        self.firebaseFunctions.fetchTasks { (aufgabenFB, error) in
            
            if let aufgaben = aufgabenFB {
                completionHandler(.success(aufgaben))
                
            } else if let error = error{
                completionHandler(.failure(error))
                return
            }
        }
        return
    }
    
    
    
    /// Fügt eine Aufgabe in Core Data hinzu.
    ///
    /// - aufgabe: aufgabe, die in Core Data gespeichert wird
    func insertAufgabeIntoCoreData(aufgabe: Aufgabe) {
        
        do {
            let newAufgabe: NSManagedObject = NSManagedObject(entity: aufgabeEntity, insertInto: context)
            
            newAufgabe.setValue(aufgabe.abgelehnt, forKey: "abgelehnt")
            newAufgabe.setValue(aufgabe.aufgeschoben, forKey: "aufgeschoben")
            newAufgabe.setValue(aufgabe.ausgespielt, forKey: "ausgespielt")
            newAufgabe.setValue(aufgabe.autor, forKey: "autor")
            newAufgabe.setValue(aufgabe.erledigt, forKey: "erledigt")
            newAufgabe.setValue(aufgabe.id, forKey: "id")
            newAufgabe.setValue(aufgabe.kategorie, forKey: "kategorie")
            newAufgabe.setValue(aufgabe.text, forKey: "text")
            newAufgabe.setValue(aufgabe.text_detail, forKey: "text_detail")
            newAufgabe.setValue(aufgabe.text_dp, forKey: "text_dp")
            
            try context.save()
            
        } catch let error {
            print("Aufgabe konnte nicht gespeichert werden: ", error)
        }
    }
    
    
    
    /// Liest alle Nutzer aus Core Data aus.
    func fetchCDAufgaben() {
        
        let getAufgaben = NSFetchRequest<NSFetchRequestResult>(entityName: "Aufgaben")
        getAufgaben.returnsObjectsAsFaults = false
        
        do {
            self.allCDAufgaben = []
            let result = try context.fetch(getAufgaben)
            
            for data in result as! [NSManagedObject] {
                
                self.allCDAufgaben.append(
                    Aufgabe(
                        abgelehnt: data.value(forKey: "abgelehnt") as! Int,
                        aufgeschoben: data.value(forKey: "aufgeschoben") as! Int,
                        ausgespielt: data.value(forKey: "ausgespielt") as! Int,
                        autor: data.value(forKey: "autor") as! String,
                        erledigt: data.value(forKey: "erledigt") as! Int,
                        id: data.value(forKey: "id") as! Int,
                        kategorie: data.value(forKey: "kategorie") as! String,
                        text: data.value(forKey: "text") as! String,
                        text_detail: data.value(forKey: "text_detail") as! String,
                        text_dp: data.value(forKey: "text_dp") as! String
                    )
                )
                
                
            }
            
        } catch {
            print("Fehler beim Abrufen der Aufgaben aus Core Data.")
        }
        
    }

    
    
}
