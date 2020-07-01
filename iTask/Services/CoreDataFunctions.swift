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
    
    
    let userEntity: NSEntityDescription
    // let aufgabeEntity: NSEntityDescription
    
    
    @Published var allCDUsers = [User]()
    // @Published var allCDAufgaben = [Aufgabe]()
    
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
        nutzername: "",
        verbliebene_aufgaben: [])
    
    
    init(firebase: FirebaseFunctions, context: NSManagedObjectContext) {
        self.firebaseFunctions = firebase
        self.context = context
        
        
        self.allCDUsers = []
        // self.allCDAufgaben = []
        
        
        self.userEntity = NSEntityDescription.entity(forEntityName: "Users", in: context)!
        // self.aufgabeEntity = NSEntityDescription.entity(forEntityName: "Aufgaben", in: context)!
        // self.curUserEntity = NSEntityDescription.entity(forEntityName: "CurUser", in: context)!
    }
    
    
    
    func getUsersFromFirebase() {
        
        
        
        self.firebaseRequest { result in
            
            do {
                self.delete()
                self.allCDUsers = []
                self.allCDUsers = try result.get()
                
                print(self.allCDUsers.count)
                self.allCDUsers.forEach {
                    print("USER: ", $0)
                }
                
                self.allCDUsers.forEach { user in
                    self.insertUserIntoCoreData(user: user)
                }
            }
                
            catch {
                self.fetchCDUsers()
            }
            
        }
    }
    
    
    
    func firebaseRequest(completionHandler: @escaping (Result<[User], Error>) -> Void) {
        
       // var tempFirebaseUsers = [User]()
            
            self.firebaseFunctions.fetchUsers { (usersFB, error) in
                
                if let users = usersFB {
                
                    // tempFirebaseUsers.append(user)
                    completionHandler(.success(users))
                    
                } else if let error = error{
                    completionHandler(.failure(error))
                    return
                }
                
            }

            return
        }
    
    

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
    
    
    
    func fetchCDUsers() {
        
        let getUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        getUsers.returnsObjectsAsFaults = false
        
        do {
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
    
    
    
    func delete(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("gelöscht")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
    
    /*
    func getCurUserFromFirebase() {
        self.firebaseFunctions.getCurrUser { (u, err) in
            if let user = u {
                
                self.loschen()
                self.insertNewCurrentUserIntoCoreData(user: user)
                self.fetchCDCurUser()
                /*
                self.deleteAllData(entity: "CurUser") { (success, error) in
                    if success != nil {
                        print("das sollte danach kommen")
                        self.insertNewCurrentUserIntoCoreData(user: user)
                        self.fetchCDCurUser()
                    } else {
                        print(error ?? "error")
                    }
                }
                */
                
            } else if let error = err {
                print("Error: \(String(describing: error))")
            }
        }
    }
   
    
    
    func insertNewCurrentUserIntoCoreData(user: User) {
        do{
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
        
        try context.save()
        }
        catch {
            print("Fehler beim Speichern des Current Users in Core Data.")
        }
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
            print("Fehler beim Abrufen des Current Users aus Core Data.")
        }
    }
     */
    

    
    /*
    func delete2(){
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false

        do {
            let items = try context.fetch(fetchRequest) as! [NSManagedObject]

            for item in items {
                context.delete(item)
            }

            // Save Changes
            try context.save()

        } catch {
            print("error deleting")
        }
    }
    */
    /*
    func getAufgabenFromFirebase() {
        self.firebaseFunctions.fetchTasks { (aufgabeModel, error) in
            if let aufgabe = aufgabeModel {
                
                self.deleteRecords(entity: "Aufgaben")
                self.insertAufgabeIntoCoreData(aufgabe: aufgabe)
                self.fetchCDAufgaben()
                
            } else if let error = error{
                print("Error: \(String(describing: error))")
            }
            
        }
    }
    
    
    
    func insertAufgabeIntoCoreData(aufgabe: Aufgabe) {
        
        do{
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
            
        try context.save()
        }
        catch {
            print("Fehler beim Speichern einer Aufgabe in Core Data.")
        }
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
            print("Fehler beim Abrufen der Aufgaben aus Core Data.")
        }
    }
    */
    
    
    
    /*
    
    
    func deleteAllData(entity: String, completionHandler: @escaping (Bool?, Error?) -> ()) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
            try context.save()
            print("deleted")
            completionHandler(true, nil)
            
        } catch let error as NSError {
            completionHandler(nil, error)
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
            
        }
    }
    */
    /*
    func deleteRecords(entity: String) {
        

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("Fehler beim Löschen.")
        }
    }
    
    func loschen(){
        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: "CurUser")
        requestDel.returnsObjectsAsFaults = false
        


           do {
                let arrUsrObj = try context.fetch(requestDel)
                for usrObj in arrUsrObj as! [NSManagedObject] { // Fetching Object
                    context.delete(usrObj) // Deleting Object
               }
           } catch {
                print("Failed deleting cur user")
           }

          // Saving the Delete operation
           do {
               try context.save()
           } catch {
               print("Failed saving")
           }
    }
*/

