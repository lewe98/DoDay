//
//  UserModel.swift
//  iTask
//
//  Created by Julian Hermanspahn on 04.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import Foundation

struct User: Identifiable {
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
    var vorname: String
}
