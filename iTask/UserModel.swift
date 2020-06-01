//
//  UserModel.swift
//  iTask
//
//  Created by Thomas on 29.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    private(set) var id: String
    private(set) var name: String
    private(set) var aufgabe: Int
    private(set) var erledigt = [Int]()
    private(set) var abgelehnt = [Int]()
    private(set) var aufgeschoben = [Int]()
    private(set) var aktueller_streak: Int
    private(set) var letztes_erledigt_datum: String //muss noch date werden
    private(set) var anzahl_benachrichtigungen: Int
}
