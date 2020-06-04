//
//  AufgabeModel.swift
//  iTask
//
//  Created by Julian Hermanspahn on 04.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import Foundation

struct Aufgabe: Identifiable {
    var abgelehnt: Int
    var aufgeschoben: Int
    var ausgespielt: Int
    var autor: String
    var erledigt: Int
    var id: Int
    var kategorie: String
    var text: String
    var text_detail: String
    var text_dp: String
    
    static func initFromDatabase(aufgabe: Aufgaben) -> Aufgabe {
        return Aufgabe(
            abgelehnt: Int(aufgabe.abgelehnt),
            aufgeschoben: Int(aufgabe.aufgeschoben),
            ausgespielt: Int(aufgabe.ausgespielt),
            autor: aufgabe.autor ?? "iTask",
            erledigt: Int(aufgabe.erledigt),
            id: Int(aufgabe.id),
            kategorie: aufgabe.kategorie ?? "Sonstiges",
            text: aufgabe.text ?? "Ooops...",
            text_detail: aufgabe.text_detail ?? "Ooops...",
            text_dp: aufgabe.text_dp ?? "Ooops..."
        )
    }
    
}
