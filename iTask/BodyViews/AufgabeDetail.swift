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
    @State private var scale: CGFloat = 0.8
    @State private var showDetail = false
    @State private var wobble = true
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 40)
                .shadow(color: .gray, radius: 20, x: 0, y: 5)
                .foregroundColor(.white)
                
                //.foregroundColor(Color(UIColor .secondarySystemFill))
            if (aufgabenGeladen) {
                Text(Aufgabe.text).lineLimit(2)
                .multilineTextAlignment(.center)
                    .foregroundColor(.blue).font(.title)
                    .padding(30)
                    // .animation(.easeInOut(duration: 0.1))
            } else {
                ActivityIndicator()
            }
            }.frame(height: 150)
            .padding()
            //.rotationEffect(.degrees(showDetail ? 90 : 0))
            //.scaleEffect(showDetail ? 1.5 : 1)
            .onAppear() {
        }

    }
}

/*
struct AufgabeDetail_Previews: PreviewProvider {
    static var previews: some View {
        AufgabeDetail(aufgabenGeladen: true, Aufgabe: "Gib Jemandem ein Kompliment.")
    }
}
*/
