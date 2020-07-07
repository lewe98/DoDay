//
//  AufgabeModel.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 04.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import Foundation

/// Dieses Struct enthält die Attribute, um ein Aufgaben-Objekt anzulegen.
struct Aufgabe: Identifiable, Hashable {
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
}

