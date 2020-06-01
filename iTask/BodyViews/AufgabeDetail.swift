//
//  AufgabeDetail.swift
//  iTask
//
//  Created by Lewe Lorenzen on 29.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct AufgabeDetail: View {
    var Aufgabe: String
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(UIColor .secondarySystemFill))
            Text(Aufgabe).padding(30)
            }.frame(height: 150)
            .padding()
    }
}

struct AufgabeDetail_Previews: PreviewProvider {
    static var previews: some View {
        AufgabeDetail(Aufgabe: "Laufe 20 Treppen, dann Laufe 20 Treppen, Laufe 20 Treppen,Laufe 20")
    }
}
