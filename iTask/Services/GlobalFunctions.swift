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
        
        //TODO: - Core Data Funktionen aufrufen
        
        isLoading = true
        isLoading = false
    }
    
    func addFriend(curUser: User){
        
    }
    
}
