//
//  AufgabeModel.swift
//  iTask
//
//  Created by Thomas on 29.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import Foundation

struct AufgabeModel: Codable {
    private(set) var id: Int
    private(set) var text: String
    private(set) var text_dp: String
    private(set) var detailtext: String
    private(set) var kategorie: String
    private(set) var autor: String
    private(set) var ausgespielt: Int
    private(set) var erledigt: Int
    private(set) var abgelehnt: Int
    private(set) var aufgeschoben: Int
}
