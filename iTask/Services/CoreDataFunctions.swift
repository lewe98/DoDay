//
//  CoreDataFunctions.swift
//  iTask
//
//  Created by Julian Hermanspahn on 04.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI
import CoreData

class CoreDataFunctions: ObservableObject {
    /*
    @Environment (\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Aufgaben.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Aufgaben.text,
                ascending: true
            )
        ]
    ) var tasksCoreData: FetchedResults<Aufgaben>

    
    public func deleteAllEntries() {
        self.tasksCoreData.forEach { aufgabe in
            self.managedObjectContext.delete(aufgabe)
        }
        try! self.managedObjectContext.save()
    }
    
    public func insertIntoCoreData(aufgabe: AufgabeModel) {
        
        // aufgabe.forEach{aufgabe in
        
        let entity = Aufgaben(context: self.managedObjectContext)
        
        entity.abgelehnt = Int16(aufgabe.abgelehnt)
        entity.aufgeschoben = Int16(aufgabe.aufgeschoben)
        entity.ausgespielt = Int16(aufgabe.ausgespielt)
        entity.autor = aufgabe.autor
        entity.erledigt = Int16(aufgabe.erledigt)
        entity.id = Int16(aufgabe.id)
        entity.kategorie = aufgabe.kategorie
        entity.text = aufgabe.text
        entity.text_detail = aufgabe.text_detail
        entity.text_dp = aufgabe.text_dp
       // }
        try! self.managedObjectContext.save()
    }
 */
}
