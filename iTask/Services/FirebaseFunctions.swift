//
//  FirebaseFunctions.swift
//  DoDay
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
    
    /// Vendor-ID des Users
    let id: String
    
    
    
    //MARK: - INITIALIZER
    /// Der Initializer übernimmt die Instanzen der Einstellungen- und der CoreDataFunctions-Klasse.
    /// Außerdem wird die registered-Variable auf ihren Status geprüft.
    init(einstellungen: Einstellungen, id: String)
    {
        self.id = id
        self.einstellungen = einstellungen
        self.registered = UserDefaults.standard.object(forKey: "registered") as? Bool ?? false
    }
    
    
    
    //MARK: - FUNCTIONS
    /// Prüft, ob ein Nutzer bereits registriert ist.
    ///
    /// - Parameter id: ID des aktuellen Nutzers
    func checkUUID() {
        db.collection("users").whereField("id", isEqualTo: self.id)
            .getDocuments() { (querySnapshot, err) in
                if (querySnapshot?.documents.count == 0) {
                    self.registered = false
                } else {
                    self.registered = true
                }
        }
    }
    
    
    
    /// Bereitet ein Nutzerobjekt auf die Registrierung vor und übergibt dieses an die setUser(...) Funktion
    /// Es wird überprüft, ob eine Freundes-ID bereits vergeben ist. Wenn ja, findet ein rekursiver Funktionaufruf statt.
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
        
        
        db.collection("users").whereField("freundes_id", isEqualTo: user.freundes_id)
            .getDocuments() { (querySnapshot, err) in
                if (querySnapshot?.documents.count == 0) {
                    self.setUser(user: user)
                    
                } else {
                    self.registerUser(id: user.id, nutzername: user.nutzername)
                }
        }
        
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
            "verbliebene_aufgaben": user.verbliebene_aufgaben,
            "nutzername": user.nutzername
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                self.checkUUID()
            }
        }
    }
    

    
    /// Generiert eine zufällige Zeichenkette. Anzahl der Symbole wird durch den Parameter bestimmt.
    ///
    /// - Parameter length: Anzahl der Symbole.
    /// - Returns: Zeichenkette als String
    func generateRandomID(length: Int) -> String {
        let letters = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    
    /// Funktion, um alle verfügbaren Aufgaben zu erhalten.
    ///
    /// - Parameter completionHandler: completionHandler
    func fetchTasks(completionHandler: @escaping ([Aufgabe]?, Error?) -> ()) {
        db.collection("aufgaben").addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("Error: \(String(describing: error))")
                completionHandler(nil, error)
                return
            }
            
            var aufgaben = [Aufgabe]()
            aufgaben = documents.map { queryDocumentSnapshot -> Aufgabe in
                
                let data = queryDocumentSnapshot.data()
                
                return Aufgabe(
                    abgelehnt: data["abgelehnt"] as? Int ?? 0,
                    aufgeschoben: data["aufgeschoben"] as? Int ?? 0,
                    ausgespielt: data["ausgespielt"] as? Int ?? 0,
                    autor: data["autor"] as? String ?? "DoDay",
                    erledigt: data["erledigt"] as? Int ?? 0,
                    id: data["id"] as? Int ?? aufgaben.count + 1,
                    kategorie: data["kategorie"] as? String ?? "Sonstiges",
                    text: data["text"] as? String ?? "Ooops...",
                    text_detail: data["text_detail"] as? String ?? "Ooops...",
                    text_dp: data["text_dp"] as? String ?? "Ooops..."
                )
            
            }
            completionHandler(aufgaben, nil)
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
            
            var users = [User]()
            users = documents.map { queryDocumentSnapshot -> User in
                
                let data = queryDocumentSnapshot.data()
                
                return User(
                    abgelehnt: data["abgelehnt"] as? [Int] ?? [],
                    aktueller_streak: data["aktueller_streak"] as? Int ?? 0,
                    anzahl_benachrichtigungen: data["anzahl_benachrichtigungen"] as? Int ?? 0,
                    aufgabe: data["aufgabe"] as? Int ?? 0,
                    aufgeschoben: data["aufgeschoben"] as? [Int] ?? [],
                    erledigt: data["erledigt"] as? [Int] ?? [],
                    freunde: data["freunde"] as? [String] ?? [],
                    freundes_id: data["freundes_id"] as? String ?? "kein Freundes-ID",
                    id: data["id"] as? String ?? "<keine ID>",
                    letztes_erledigt_datum: data["letztes_erledigt_datum"] as? Date ?? Date(),
                    nutzername: data["nutzername"] as? String ?? "<kein Nutzername>",
                    verbliebene_aufgaben: data["verbliebene_aufgaben"] as? [Int] ?? [])
                
            }
            completionHandler(users, nil)
        }
    }
    
    
    
    
    /// Fügt eine Person der eigenen Freundesliste hinzu.
    ///
    /// - Parameter curUser: der aktuelle User
    /// - Parameter freundID: ID des Freundes
    func addFriend(curUser: User, freundID: String) {
        
        db.collection("users").whereField("freundes_id", isEqualTo: freundID)
            .getDocuments() { (querySnapshot, err) in
                
                if (querySnapshot?.documents.count == 0) {
                    print("User konnte nicht gefunden werden.")
                    
                } else {
                    var newFriendList = curUser.freunde
                    newFriendList.append(freundID)
                    
                    self.db.collection("users").document(curUser.id).updateData([
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
        }
    }
  
    
    
       /// Ermittelt die höchste Aufgaben-ID.
       ///
       /// - Returns: Höchste Aufgaben-ID
    func getAufgabenHighestID() -> Int {
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
            id: getAufgabenHighestID() + 1,
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
    
    
    
    /// Inkremetiert die Anzahl der User, die eine spezifische Aufgabe erledigt haben.
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
    
    
    
}
