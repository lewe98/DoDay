//
//  GlobalFunctions.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 29.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import Foundation

class GlobalFunctions: ObservableObject {
    
    // MARK: - VARIABLES
    /// Ladestatus
    @Published var isLoading: Bool = true
    
    /// Freundesliste fuer FreundeView
    @Published var freundesListe: [Freund] = []
    
    /// Firebase
    let firebaseFunctions: FirebaseFunctions
    
    /// Core Data
    let coreDataFunctions: CoreDataFunctions
    
    
    
    // MARK: - INITIALIZER
    init(firebase: FirebaseFunctions, coreData: CoreDataFunctions) {
        self.firebaseFunctions = firebase
        self.coreDataFunctions = coreData
    }
    
    
    
    // MARK: - FUNCTIONS
    /// Funktion, um beim Starten der App alle Daten zu aktualisieren
    func load() {
        
        isLoading = true
        
        self.coreDataFunctions.getUsersFromFirebase()
        self.coreDataFunctions.getAufgabenFromFirebase()
        
        
        isLoading = false
    }
    
    
    
    /// Fügt eine Person der eigenen Freundesliste hinzu.
    ///
    /// - Parameter freundID: ID des Freundes
    func callAddFriend(freundID: String){
        self.firebaseFunctions.addFriend(
            curUser: self.coreDataFunctions.curUser,
            freundID: freundID)
    }
    
    
    // Aktualisiert die Freundesliste, die im FreundeView angezeigt wird.
    func updateFreundesListe() {
        
        self.coreDataFunctions.getUsersFromFirebase()
        
        self.freundesListe = []
        
        self.coreDataFunctions.curUser.freunde.forEach { freundID in // alle Freunde durchgehen (freundes_id)
            self.coreDataFunctions.allCDUsers.forEach { user in // User rausziehen
                if user.freundes_id == freundID {
                    var text = "Keine Aufgabe ausgewählt"
                    self.coreDataFunctions.allCDAufgaben.forEach { aufgabe in // Aufgaben rausziehen
                        if user.aufgabe == aufgabe.id {
                            text = aufgabe.text_dp
                        }
                    }
                    self.freundesListe.append(
                        Freund(
                            nutzername: user.nutzername,
                            freundes_id: user.freundes_id,
                            erledigt: user.erledigt.count,
                            text_dp: text))
                }
            }
        }
    }
    
}
