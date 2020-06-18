//
//  FirebaseFunctions.swift
//  iTask
//
//  Created by Julian Hermanspahn on 04.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import Foundation
import Firebase
import Combine
import SwiftUI

class FirebaseFunctions: ObservableObject {
    let db = Firestore.firestore()
    // MARK: - registered Variable
    // unten in Zeil 151 wird sie auf true gesetzt (nachdem bei Firebase ein User erstellt und auch lokal gespeichert wurde)
    @EnvironmentObject var einstellungen: Einstellungen
    // @Published var registered: Bool = false
    @Published var aufgaben = [Aufgabe]()
    @Published var users = [User]()
    @Published var curUser: User = User(
        abgelehnt: [],
        aktueller_streak: 0,
        anzahl_benachrichtigungen: 0,
        aufgabe: 0,
        aufgeschoben: [],
        erledigt: [],
        freunde: [],
        freundes_id: "x",
        id: "x",
        letztes_erledigt_datum: Date(),
        verbliebene_aufgaben: [],
        vorname: "x")
    // user ist registriert
    @Published var registered: Bool {
        didSet {
            UserDefaults.standard.set(registered, forKey: "registered")
        }
    }
    init() {
        self.registered = UserDefaults.standard.object(forKey: "registered") as? Bool ?? false
    }
    //@Environment (\.managedObjectContext) var managedObjectContext
    
    
    
    func checkUUID(id: String) {
        db.collection("users").whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.registered = false
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                    self.registered = true
                }
        }
    }
    
    
    
    func registerUser(id: String, vorname: String){
        let user = User(
            abgelehnt: [],
            aktueller_streak: 0,
            anzahl_benachrichtigungen: 0,
            aufgabe: 0,
            aufgeschoben: [],
            erledigt: [],
            freunde: [],
            freundes_id: randomString(length: 8),
            id: id,
            letztes_erledigt_datum: Date(),
            verbliebene_aufgaben: [],
            vorname: vorname)
        
        setUser(user: user)
        
        // MARK: - TODO, check if freundes_id is already taken
        /*
         db.collection("users").whereField("freundes_id", isEqualTo: user.freundes_id)
         .getDocuments() { (querySnapshot, err) in
         if let err = err {
         print("Error getting documents: \(err)")
         self.setUser(user: user)
         } else {
         for document in querySnapshot!.documents {
         print("\(document.documentID) => \(document.data())")
         self.registerUser(id: user.id, vorname: user.vorname)
         }
         }
         }*/
    }
    
    
    
    func setUser(user: User){
        db.collection("users").document(user.id).setData([
            "abgelehnt": user.abgelehnt,
            "aktueller_streak": user.aktueller_streak,
            "anzahl_benachrichtigungen": user.anzahl_benachrichtigungen,
            "aufgabe": user.aufgabe,
            "aufgeschoben": user.aufgeschoben,
            "erledigt": user.erledigt,
            "freunde": user.freunde,
            "freundes_id": user.freundes_id,
            "id": user.id,
            // "letztes_erledigt_datum": Timestamp(date: user.letztes_erledigt_datum),
            "verbliebene_aufgaben": user.verbliebene_aufgaben,
            "vorname": user.vorname
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.getCurrUser()
            }
        }
    }
    
    
    
    func getCurrUser() {
        let id: String = UIDevice.current.identifierForVendor!.uuidString
        db.collection("users").document(id).getDocument { (document, error) in
            if let document = document, document.exists {
                
                let data = document.data()!
                
                let abgelehnt = data["abgelehnt"] as? [Int] ?? []
                let aktueller_streak = data["aktueller_streak"] as? Int ?? 0
                let anzahl_benachrichtigungen = data["anzahl_benachrichtigungen"] as? Int ?? 0
                let aufgabe = data["aufgabe"] as? Int ?? 0
                let aufgeschoben = data["aufgeschoben"] as? [Int] ?? []
                let erledigt = data["erledigt"] as? [Int] ?? []
                let freunde = data["freunde"] as? [String] ?? []
                let freundes_id = data["freundes_id"] as? String ?? "kein Freundes-ID"
                let id = data["id"] as? String ?? UIDevice.current.identifierForVendor!.uuidString
                let letztes_erledigt_datum = data["letztes_erledigt_datum"] as? Date ?? Date()
                let verbliebene_aufgaben = data["verbliebene_aufgaben"] as? [Int] ?? []
                let vorname = data["vorname"] as? String ?? "<kein Vorname>"
                
                self.curUser.abgelehnt = abgelehnt
                self.curUser.aktueller_streak = aktueller_streak
                self.curUser.anzahl_benachrichtigungen = anzahl_benachrichtigungen
                self.curUser.aufgabe = aufgabe
                self.curUser.aufgeschoben = aufgeschoben
                self.curUser.erledigt = erledigt
                self.curUser.freunde = freunde
                self.curUser.freundes_id = freundes_id
                self.curUser.id = id
                self.curUser.letztes_erledigt_datum = letztes_erledigt_datum
                self.curUser.verbliebene_aufgaben = verbliebene_aufgaben
                self.curUser.vorname = vorname
                
                print("current user: ", self.curUser)
            
                self.registered = true

                // insert into core data
                //let entity = Users(context: self.managedObjectContext)
                
                

                /*
                 let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                 print("Document data: \(dataDescription)")
                 */
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    

    func addFriend(user: User, freundID: String) {
        
        var newFriendList = user.freunde
        newFriendList.append(freundID)
        
        db.collection("users").document(user.id).updateData([
            "freunde": newFriendList
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
    
    func getAufgabenCollectionSize() -> Int {
        
        var count: Int = 0
        
        db.collection("aufgaben").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let id = document.data()["id"] as? Int ?? 0
                    
                    if id > count {
                        count = id
                    }
                }
            }
        }
        
        return count
    }
    
    
    
    
    func addNewAufgabe(text: String, text_detail: String, text_dp: String, kategorie: String){
        
        let aufgabe = Aufgabe(
            abgelehnt: 0,
            aufgeschoben: 0,
            ausgespielt: 0,
            autor: "DoDay",
            erledigt: 0,
            id: getAufgabenCollectionSize() + 1,
            kategorie: kategorie,
            text: text,
            text_detail: text_detail,
            text_dp: text_dp)
        
        db.collection("aufgaben").document(String(aufgabe.id)).setData([
            "abgelehnt": aufgabe.abgelehnt
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            } 
        }
    }
    
    
    
    func incrementErledigt(aufgabe: Aufgabe){
        db.collection("aufgaben").document(String(aufgabe.id)).updateData([
            "erledigt": aufgabe.erledigt + 1
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
    
    func fetchTasks(completionHandler: @escaping (Aufgabe?, Error?) -> ()) {
        db.collection("aufgaben").addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("Error: \(String(describing: error))")
                completionHandler(nil, error)
                return
            }
            
            self.aufgaben = documents.map { queryDocumentSnapshot -> Aufgabe in
                
                let data = queryDocumentSnapshot.data()
                
                let abgelehnt = data["abgelehnt"] as? Int ?? 0
                let aufgeschoben = data["aufgeschoben"] as? Int ?? 0
                let ausgespielt = data["ausgespielt"] as? Int ?? 0
                let autor = data["autor"] as? String ?? "DoDay"
                let erledigt = data["erledigt"] as? Int ?? 0
                let id = data["id"] as? Int ?? self.aufgaben.count
                let kategorie = data["kategorie"] as? String ?? "Sonstiges"
                let text = data["text"] as? String ?? "Ooops..."
                let text_detail = data["text_detail"] as? String ?? "Ooops..."
                let text_dp = data["text_dp"] as? String ?? "Ooops..."
                
                let aufgabe = Aufgabe(
                    abgelehnt: abgelehnt,
                    aufgeschoben: aufgeschoben,
                    ausgespielt: ausgespielt,
                    autor: autor,
                    erledigt: erledigt,
                    id: id,
                    kategorie: kategorie,
                    text: text,
                    text_detail: text_detail,
                    text_dp: text_dp
                )
                
                completionHandler(aufgabe, nil)
                return aufgabe
            }
        }
    }
    
    
    
    func fetchUsers(completionHandler: @escaping (User?, Error?) -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("Error: \(String(describing: error))")
                completionHandler(nil, error)
                return
            }
            
            self.users = documents.map { queryDocumentSnapshot -> User in
                
                let data = queryDocumentSnapshot.data()
                
                let abgelehnt = data["abgelehnt"] as? [Int] ?? []
                let aktueller_streak = data["aktueller_streak"] as? Int ?? 0
                let anzahl_benachrichtigungen = data["anzahl_benachrichtigungen"] as? Int ?? 0
                let aufgabe = data["aufgabe"] as? Int ?? 0
                let aufgeschoben = data["aufgeschoben"] as? [Int] ?? []
                let erledigt = data["erledigt"] as? [Int] ?? []
                let freunde = data["freunde"] as? [String] ?? []
                let freundes_id = data["freundes_id"] as? String ?? "kein Freundes-ID"
                let id = data["id"] as? String ?? UIDevice.current.identifierForVendor!.uuidString
                let letztes_erledigt_datum = data["letztes_erledigt_datum"] as? Date ?? Date()
                let verbliebene_aufgaben = data["verbliebene_aufgaben"] as? [Int] ?? []
                let vorname = data["vorname"] as? String ?? "<kein Vorname>"
                
                let user = User(
                    abgelehnt: abgelehnt,
                    aktueller_streak: aktueller_streak,
                    anzahl_benachrichtigungen: anzahl_benachrichtigungen,
                    aufgabe: aufgabe,
                    aufgeschoben: aufgeschoben,
                    erledigt: erledigt,
                    freunde: freunde,
                    freundes_id: freundes_id,
                    id: id, letztes_erledigt_datum: letztes_erledigt_datum,
                    verbliebene_aufgaben: verbliebene_aufgaben,
                    vorname: vorname)
                
                completionHandler(user, nil)
                return user
            }
        }
    }
    
    

}
