//
//  UserModel.swift
//  iTask
//
//  Created by Julian Hermanspahn on 04.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import Foundation

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
    var vorname: String
    
    static func initUserFromDatabase(user: Users) -> User {
        return User(
            abgelehnt: user.abgelehnt as! [Int],
            aktueller_streak: Int(user.aktueller_streak),
            anzahl_benachrichtigungen: Int(user.anzahl_benachrichtigungen),
            aufgabe: Int(user.aufgabe),
            aufgeschoben: user.aufgeschoben as! [Int],
            erledigt: user.erledigt as! [Int],
            freunde: user.freunde as! [String],
            freundes_id: user.freundes_id ?? "<keine Freundes-ID>",
            id: user.id ?? "<keine ID>",
            letztes_erledigt_datum: user.letztes_erledigt_datum ?? Date(),
            verbliebene_aufgaben: user.verbliebene_aufgaben as! [Int],
            vorname: user.vorname ?? "<kein Vorname>")
    }
    
    static func initCurUserFromDatabase(user: CurUser) -> User {
        return User(
            abgelehnt: user.abgelehnt as! [Int],
            aktueller_streak: Int(user.aktueller_streak),
            anzahl_benachrichtigungen: Int(user.anzahl_benachrichtigungen),
            aufgabe: Int(user.aufgabe),
            aufgeschoben: user.aufgeschoben as! [Int],
            erledigt: user.erledigt as! [Int],
            freunde: user.freunde as! [String],
            freundes_id: user.freundes_id ?? "<keine Freundes-ID>",
            id: user.id ?? "<keine ID>",
            letztes_erledigt_datum: user.letztes_erledigt_datum ?? Date(),
            verbliebene_aufgaben: user.verbliebene_aufgaben as! [Int],
            vorname: user.vorname ?? "<kein Vorname>")
    }
}
