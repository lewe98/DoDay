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
    
    /// Nimmt ein Userobjekt aus Core Data entgegen (Users) und konvertiert dieses zum Typ User.
    ///
    /// - Parameter value: user - user aus Core Data
    /// - Returns: konvertierter User
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
            nutzername: user.nutzername ?? "<kein Nutzername>")
    }
    
    /// Nimmt ein Userobjekt aus Core Data entgegen (CurUser) und konvertiert dieses zum Typ User.
    ///
    /// - Parameter value: user - user aus Core Data
    /// - Returns: konvertierter User
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
            nutzername: user.nutzername ?? "<kein Nutzername>")
    }
}
