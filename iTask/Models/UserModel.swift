//
//  UserModel.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 04.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import Foundation

/// Dieses Struct enthält die Attribute, um ein User-Objekt anzulegen.
struct User: Identifiable, Hashable {
    var abgelehnt: [Int]
    var aktueller_streak: Int
    var anzahl_benachrichtigungen: Int
    var aufgabe: Int
    var aufgeschoben: [Int]
    var erledigt: [Int]
    var freunde: [String]
    var freundes_id: String
    var id: String
    var letztes_erledigt_datum: Date
    var verbliebene_aufgaben: [Int]
    var nutzername: String
}
