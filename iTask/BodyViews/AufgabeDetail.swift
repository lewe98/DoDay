//
//  AufgabeDetail.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 29.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct AufgabeDetail: View {
    let aufgabenGeladen: Bool
    let Aufgabe: Aufgabe
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 40)
                .shadow(color: .gray, radius: 20, x: 0, y: 5)
                .foregroundColor(.white)
                
                //.foregroundColor(Color(UIColor .secondarySystemFill))
            if (aufgabenGeladen) {
                Text(Aufgabe.text).lineLimit(nil)
                .multilineTextAlignment(.center)
                    .foregroundColor(.blue).font(.title)
                    .padding(30)
            } else {
                ActivityIndicator()
            }
            }.frame(height: 150)
            .padding()

    }
}

/*
struct AufgabeDetail_Previews: PreviewProvider {
    static var previews: some View {
        AufgabeDetail(aufgabenGeladen: true, Aufgabe: "Gib Jemandem ein Kompliment.")
    }
}
*/
