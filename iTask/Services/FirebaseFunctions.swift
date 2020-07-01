//
//  FirebaseFunctions.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 04.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import Foundation
import Firebase
import Combine
import SwiftUI

/// Diese Klasse enthält sämtliche Funktionen zur Kommunikation mit dem Firebase Backend.
class FirebaseFunctions: ObservableObject {
    
    
    
// MARK: - VARIABLES
    /// Die Einstellungen des Users.
    let einstellungen: Einstellungen
    
    
    /// Die Firebase Datenbank (Firestore).
    let db = Firestore.firestore()
    
    /// Der Regisitrierungstatus des aktiven Users.
    @Published var registered: Bool {
        didSet {
            UserDefaults.standard.set(registered, forKey: "registered")
        }
    }
    
    /// leeres Aufgaben-Array
    @Published var aufgaben = [Aufgabe]()
    
    /// leeres User-Array
    @Published var users = [User]()
    
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
    
    
    
//MARK: - INITIALIZER
    /// Der Initializer übernimmt die Instanzen der Einstellungen- und der CoreDataFunctions-Klasse.
    /// Außerdem wird die registered-Variable auf ihren Status geprüft.
    init(einstellungen: Einstellungen)
    {
        self.einstellungen = einstellungen
        self.registered = UserDefaults.standard.object(forKey: "registered") as? Bool ?? false
    }
    
    
    
//MARK: - FUNCTIONS
    /// Prüft, ob ein Nutzer bereits registriert ist.
    ///
    /// - Parameter id: ID des aktuellen Nutzers
    func checkUUID(id: String) {
        db.collection("users").whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if (querySnapshot?.documents.count == 0) {
                    print("Error getting documents!")
                    self.registered = false
                } else {
                    for _ in querySnapshot!.documents {
                        //for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                    }
                    self.registered = true
                }
        }
    }
    
    
    
    /// Bereitet ein Nutzerobjekt auf die Registrierung vor und übergibt dieses an die setUser(...) Funktion
    ///
    /// - Parameter id: ID des aktuellen Nutzers
    /// - Parameter nutzername: der vom User ausgewählte Nutzername
    func registerUser(id: String, nutzername: String){
        let user = User(
            abgelehnt: [],
            aktueller_streak: 0,
            anzahl_benachrichtigungen: 0,
            aufgabe: 0,
            aufgeschoben: [],
            erledigt: [],
            freunde: [],
            freundes_id: generateRandomID(length: 8),
            id: id,
            letztes_erledigt_datum: Date(),
            nutzername: nutzername,
            verbliebene_aufgaben: [])
        
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
         self.registerUser(id: user.id, nutzername: user.nutzername)
         }
         }
         }*/
    }
    
    
    
    /// Registriert einen neuen Nutzer in der Datenbank.
    ///
    /// - Parameter user: Nutzer der registriert wird
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
            "nutzername": user.nutzername
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.getCurrUser { (u, err) in
                    if u != nil {}
                }
            }
        }
    }
    
    
    
    /// Funktion, um die Attribute des aktuellen Nutzers zu erhalten
    ///
    /// - Parameter completionHandler:completionHandler
    func getCurrUser(completionHandler: @escaping (User?, Error?) -> ()) {
        let id: String = UIDevice.current.identifierForVendor?.uuidString ?? "<keine ID>"
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
                let id = data["id"] as? String ?? UIDevice.current.identifierForVendor?.uuidString ?? "<keine ID>"
                let letztes_erledigt_datum = data["letztes_erledigt_datum"] as? Date ?? Date()
                let verbliebene_aufgaben = data["verbliebene_aufgaben"] as? [Int] ?? []
                let nutzername = data["nutzername"] as? String ?? "<kein Nutzername>"
                
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
                self.curUser.nutzername = nutzername
                
                self.registered = true
                
                completionHandler(self.curUser, nil)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    
    /// Generiert eine zufällige Zeichenkette. Anzahl der Symbole wird durch den Parameter bestimmt.
    ///
    /// - Parameter length: Anzahl der Symbole.
    /// - Returns: Zeichenkette als String.
    func generateRandomID(length: Int) -> String {
        let letters = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    
    /// Fügt eine Person der eigenen Freundesliste hinzu.
    ///
    /// - Parameter freundID: ID des zu hinzuzufügenden Freundes.
    func addFriend(freundID: String) {
        print("ADDFRIEND WIRD ERFOLGREICH AUSGELOEST. freundID: \(freundID)")
        var success: Bool = false
        /*db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting users: \(err)")
            } else {
                for user in querySnapshot!.documents {
                    if user.freundes_id == freundID {
                        success = true
                        break
                    }
                }
                if success == true {*/
                    var newFriendList = curUser.freunde
                    newFriendList.append(freundID)
                    
                    db.collection("users").document(curUser.id).updateData([
                        "freunde": newFriendList
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            
                            //MARK: - TODO: In Core Data speichern
                        }
                    }
                }
         //   }
       // }
    
   // }
    
    
    
       /// Ermittelt die Anzahl aller verfügbaren Aufgaben.
       ///
       /// - Returns: Anzahl aller Aufgaben als Integer.
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
    
    
    
    /// Fügt der Datenbank eine neue Aufgabe hinzu.
    ///
    /// - Parameter text: Kurztext
    /// - Parameter text_detail: Detaillierter Text
    /// - Parameter text_dp: Text aus der dritten Person
    /// - Parameter kategorie: Kategorie der Aufgabe
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
    
    
    
    /// Inkremetiert die Anzahl der User, die die Aufgabe erledigt haben
    ///
    /// - Parameter aufgabe: Aufgabe die bearbeitet wird
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
    
    
    
    /// Funktion, um alle verfügbaren Aufgaben zu erhalten.
    ///
    /// - Parameter completionHandler: completionHandler
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
    
    
    
    /// Funktion, um alle verfügbaren User zu erhalten.
    ///
    /// - Parameter completionHandler: completionHandler
    func fetchUsers(completionHandler: @escaping ([User]?, Error?) -> ()) {
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
                let id = data["id"] as? String ?? UIDevice.current.identifierForVendor?.uuidString ?? "<keine ID>"
                let letztes_erledigt_datum = data["letztes_erledigt_datum"] as? Date ?? Date()
                let verbliebene_aufgaben = data["verbliebene_aufgaben"] as? [Int] ?? []
                let nutzername = data["nutzername"] as? String ?? "<kein Nutzername>"
                
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
                    nutzername: nutzername,
                    verbliebene_aufgaben: verbliebene_aufgaben)
                
                
                return user
            }
            completionHandler(self.users, nil)
        }
    }
    
    
    
}
