//
//  AufgabeDetail.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 29.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct AufgabeDetail: View {
    var Aufgabe: String
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 40)
                .shadow(color: .gray, radius: 20, x: 0, y: 5)
                .foregroundColor(.white)
                
                //.foregroundColor(Color(UIColor .secondarySystemFill))
            Text(Aufgabe).lineLimit(nil)
            .multilineTextAlignment(.center)
                .foregroundColor(.blue).font(.title)
                .padding(30)
            }.frame(height: 150)
            .padding()
    }
}

struct AufgabeDetail_Previews: PreviewProvider {
    static var previews: some View {
        AufgabeDetail(Aufgabe: "Gib Jemandem ein Kompliment.")
    }
}
