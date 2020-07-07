//
//  CoreDataFunctions.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 04.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

/// Diese Klasse enthält sämtliche Funktionen zur Kommunikation mit Core Data.
class CoreDataFunctions: ObservableObject {
    
    // MARK: - VARIABLES
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
        aufgabe: -1,
        aufgeschoben: [],
        erledigt: [],
        freunde: [],
        freundes_id: "loading...",
        id: "loading...",
        letztes_erledigt_datum: Date(),
        nutzername: "loading...",
        verbliebene_aufgaben: [])
    
    @Published var aufgabenView = -1
    /// Vendor-ID des Users
    let id: String
    
    
    
    //MARK: - INITIALIZER
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
        if self.firebaseFunctions.registered {
            self.curUser = self.allCDUsers.first(where: {$0.id == self.id})!
            self.setHeuteView()
        }
    }
    
    func setHeuteView() {
        if (self.curUser.aufgabe == 0){
            self.aufgabenView = 3
        } else if (self.curUser.aufgabe > 0) {
            self.aufgabenView = 2
        } else {
            self.aufgabenView = 1
        }
    }
    
    
    
    func getAufgabeByID(id: Int) -> Aufgabe? {
        if id == -1 {
            return Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "DoDay", erledigt: 0, id: 0, kategorie: "", text: "loading...", text_detail: "loading...", text_dp: "loading...")
        }
        return self.allCDAufgaben.filter({ (aufgabe) -> Bool in
            aufgabe.id == id
        }).first
    }
    
    
    
    func curUserVerbliebeneAufgabenUpdaten(done: @escaping (Result<String, Error>) -> Void) {
        var fertigeAufgaben = self.curUser.erledigt
        let alleAufgaben = self.allCDAufgaben.map{ aufgabe -> Int in
            aufgabe.id
        }
        fertigeAufgaben.append(contentsOf: self.curUser.aufgeschoben)
        fertigeAufgaben.append(contentsOf: self.curUser.abgelehnt)
        self.curUser.verbliebene_aufgaben =
            //allCDAufgaben.map{ (aufgaben: Aufgabe) -> Aufgabe{}
            alleAufgaben.filter{
            (aufgabeCD) -> Bool in
            var ruckgabe = true
                let bool = fertigeAufgaben.map { tmpAufgabe -> Bool in
                    if (tmpAufgabe == aufgabeCD) {
                        return false
                    } else {
                        return true
                    }
                }
            bool.forEach { boolItem in
                if (boolItem == false) {
                    ruckgabe = false
                }
            }
            return ruckgabe
        }
        firebaseFunctions.updateUser(user: self.curUser, done: {_ in
            self.getCurUser()
        })
        if ((self.curUser.verbliebene_aufgaben.count + self.curUser.aufgeschoben.count) < 3) {
            done(.failure(NSError()))
        } else {
            done(.success("Success!"))
        }
    }
    
    
    
    func verbliebeneAufgabenAnzeigen(aufgabeDone: @escaping (Result<[Aufgabe?], Error>) -> Void) -> Void {
        return self.curUserVerbliebeneAufgabenUpdaten() { result in
            do {
                let _ = try result.get()
                var verbliebeneAufgaben = self.curUser.verbliebene_aufgaben
                verbliebeneAufgaben.append(contentsOf: self.curUser.aufgeschoben)
                
                var randomNumber = Int.random(in: 0..<(verbliebeneAufgaben.count))
                
                let aufgabe1 = self.getAufgabeByID(id: verbliebeneAufgaben[randomNumber])
                
                verbliebeneAufgaben.remove(at: randomNumber)
                
                randomNumber = Int.random(in: 0..<(verbliebeneAufgaben.count))
                
                let aufgabe2 = self.getAufgabeByID(id: verbliebeneAufgaben[randomNumber])
                aufgabeDone(.success([aufgabe1, aufgabe2]))
            }
            catch let error {
                aufgabeDone(.failure(error))
            }
        }
        
    }
    
    
    
    func aktuelleAufgabeAuswaehlen(aufgabe: Aufgabe) {
        var aufgabeTmp = aufgabe
        self.curUser.aufgabe = aufgabe.id
        let index = self.curUser.verbliebene_aufgaben.firstIndex(of: aufgabe.id)
        if (index != nil) {
            self.curUser.verbliebene_aufgaben.remove(at: index!)
        } else {
            print("chooseAufgabe(): Aufgabe not found!")
        }
        self.updateCurUser() { result in
            do {
                let _ = try result.get()
                // Zeigt den SecondHeuteView an
                self.aufgabenView = 2
            } catch {
                // Zeigt Datenbankfehler an
                self.aufgabenView = 3
            }
        aufgabeTmp.ausgespielt += 1
        self.updateAufgabe(aufgabe: aufgabeTmp)
        }
    }
    
    func aufgabeErledigt() {
        let id = self.curUser.aufgabe
        if let index = self.curUser.aufgeschoben.firstIndex(of: id) {
            self.curUser.aufgeschoben.remove(at: index)
        }
        self.curUser.erledigt.append(self.curUser.aufgabe)
        self.curUser.aufgabe = -1
        self.updateCurUser() { result in
            do {
                let _ = try result.get()
                // Zeigt den firstHeuteView an
                self.aufgabenView = 1
            } catch {
                // Zeigt Datenbankfehler an
                self.aufgabenView = 3
            }
        }
        if var aufgabe = self.getAufgabeByID(id: id) {
        aufgabe.erledigt += 1
        self.updateAufgabe(aufgabe: aufgabe)
        }
    }
    
    func aufgabeAufschieben() {
        let id = self.curUser.aufgabe
        if (!self.curUser.aufgeschoben.contains(id)) {
            self.curUser.aufgeschoben.append(self.curUser.aufgabe)
        }
        self.curUser.aufgabe = -1
        self.updateCurUser() { result in
            do {
                let _ = try result.get()
                // Zeigt den firstHeuteView an
                self.aufgabenView = 1
            } catch {
                // Zeigt Datenbankfehler an
                self.aufgabenView = 3
            }
        }
        if var aufgabe = self.getAufgabeByID(id: id) {
        aufgabe.aufgeschoben += 1
        self.updateAufgabe(aufgabe: aufgabe)
        }
    }
    
    func aufgabeAblehnen() {
        let id = self.curUser.aufgabe
        if let index = self.curUser.aufgeschoben.firstIndex(of: id) {
            self.curUser.aufgeschoben.remove(at: index)
        }
        self.curUser.abgelehnt.append(self.curUser.aufgabe)
        self.curUser.aufgabe = -1
        self.updateCurUser() { result in
            do {
                let _ = try result.get()
                // Zeigt den firstHeuteView an
                self.aufgabenView = 1
            } catch {
                // Zeigt Datenbankfehler an
                self.aufgabenView = 3
            }
        }
        if var aufgabe = self.getAufgabeByID(id: id) {
        aufgabe.abgelehnt += 1
        self.updateAufgabe(aufgabe: aufgabe)
        }
    }
    
    func updateCurUser(done: @escaping (Result<String, Error>) -> Void) {
        self.firebaseFunctions.updateUser(user: self.curUser, done: { result in
            do {
                print(try result.get())
                self.getUsersFromFirebase()
                done(.success("Sucsess"))
            } catch let error {
                done(.failure(error))
            }
        })
    }
    
    func updateAufgabe(aufgabe: Aufgabe) {
        self.firebaseFunctions.updateAufgabe(aufgabe: aufgabe, done: { result in
            do {
                print(try result.get())
                self.getAufgabenFromFirebase()
            } catch let error {
                print(error)
            }
        })
    }
    
    
    
    func getCurAufgabe() -> Aufgabe {
        if self.curUser.aufgabe > 0 {
            return self.allCDAufgaben.first(where: {$0.id == self.curUser.aufgabe})!
        }
        return Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "DoDay", erledigt: 0, id: 0, kategorie: "", text: "Keine Aufgabe verfügbar.", text_detail: "Keine Aufgabe verfügbar.", text_dp: "Keine Aufgabe verfügbar.")
    }
    
    
    
    func getZuletztErledigt() -> Aufgabe {
        
        //var returnString: String = "Noch keine Aufgabe erledigt."
        
        if self.curUser.erledigt.count > 0 {
            let tempAufgabe = self.allCDAufgaben.first(where: {
                $0.id == self.curUser.erledigt[self.curUser.erledigt.count - 1]
            })!
            return tempAufgabe
            //returnString = tempAufgabe.text
        }
        
        return Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "DoDay", erledigt: 0, id: 0, kategorie: "", text: "Noch keine Aufgabe erledigt.", text_detail: "Noch keine Aufgabe erledigt.", text_dp: "Noch keine Aufgabe erledigt.")
    }
    
    
    func checkIfErledigt(id: Int) -> Bool {
        
        var test = 0
        
        self.curUser.erledigt.forEach { aufgabe in
            if aufgabe == id {
                test = 1
            }
            
        }
        
        if test == 1 {
            return true
        }
        return false

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
                self.setHeuteView()
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
