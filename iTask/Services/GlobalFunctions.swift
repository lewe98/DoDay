//
//  GlobalFunctions.swift
//  iTask
//
//  Created by Julian Hermanspahn on 29.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import Foundation

class GlobalFunctions: ObservableObject {
    
    @Published var isLoading: Bool = true
    
    func load() {
        
        //TODO: - Core Data Funktionen aufrufen
        
        isLoading = true
        isLoading = false
    }
}
