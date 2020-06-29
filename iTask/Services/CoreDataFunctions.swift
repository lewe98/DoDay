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
    
    //let userEntity: NSEntityDescription
    //let aufgabeEntity: NSEntityDescription
    
    let firebaseFunctions: FirebaseFunctions
    
    let curUserEntity: NSEntityDescription
    
    let newCurrentUser: NSManagedObject
    
    var curUserResult: User = User(
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
    
    let context: NSManagedObjectContext
    
    init(firebase: FirebaseFunctions) {
        
        self.firebaseFunctions = firebase
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        
        //userEntity = NSEntityDescription.entity(forEntityName: "Users", in: context)!
        //aufgabeEntity = NSEntityDescription.entity(forEntityName: "Aufgaben", in: context)!
        self.curUserEntity = NSEntityDescription.entity(forEntityName: "CurUser", in: context)!
        
        self.newCurrentUser = NSManagedObject(entity: curUserEntity, insertInto: context)
    }
    
  
    func getCurUserFromFirebase(){
        self.firebaseFunctions.getCurrUser { (u, err) in
            if let user = u {
                
                self.insertNewCurrentUserIntoCoreData(user: user)
                
                self.fetchCDCurUser()
                /*
                self.insertCurUserIntoCoreData(user: user) { (nil, error) in
                    if let error = error{
                        print(error)
                    } else {
                        self.cdCurUser.append(user)
                        print("CURRENT USER AUS CORE DATA: ", user, self.cdCurUser.count)
                        print("\n\n\n\n CONTENTVIEW curUser.count ist: \(self.cdCurUser.count) bzw. der curUser: \n \(self.cdCurUser)\n\n\n")
                        self.initCurAufgabe(id: user.aufgabe)
                    }
                }
                */
            } else if let error = err{
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
   
    
    
        
      
        
        
        func saveCoreData(){
            do {
                try context.save()
            } catch {
                print("Failed saving.")
            }
        }
        
        
    /*
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
        
    
    
        func fetchCDUsers(){
            let getUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            //request.predicate = NSPredicate(format: "age = %@", "12")
            getUsers.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(getUsers)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "username") as! String)
                }
                
            } catch {
                print("Failed")
            }
        }
        */
    
    
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
    
   
    
}
