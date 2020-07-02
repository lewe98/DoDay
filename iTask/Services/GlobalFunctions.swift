//
//  GlobalFunctions.swift
//  iTask
//
//  Created by Julian Hermanspahn on 29.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import Foundation

class GlobalFunctions: ObservableObject {
    
    // MARK: - VARIABLES
    /// Ladestatus
    @Published var isLoading: Bool = true
    
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
    
}
