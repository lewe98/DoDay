//
//  additives_diagramm.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 30.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct Additives_diagramm: View {
    var erledigteA = 0
    var nichtErledigteA = 0
    var aufgeschobeneA = 0
    private let screenWidth = Float(UIScreen.main.bounds.width)
    @State var erledigteAFloat = CGFloat(0)
    @State var nichtErledigteAFloat = CGFloat(0)
    @State var aufgeschobeneAFloat = CGFloat(0)
    @State var nurNichtErledigt = CGFloat(0)
    var body: some View {
        switch (erledigteA + nichtErledigteA + aufgeschobeneA) {
        case 0:
            return
                AnyView(
                    HStack {
                        Spacer()
                        Text("Es ist noch keine Statistik verfügbar")
                        ActivityIndicator()
                        Spacer()
                    })
        default:
            return
                AnyView(
                    VStack{
                        ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(Color(UIColor .secondarySystemFill))
                                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 24)
                            
                            HStack {
                                if erledigteA != 0 {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.systemBlue)
                                    .frame(maxWidth: erledigteAFloat, maxHeight: 16)
                                    .animation(Animation.easeInOut(duration: 1).delay(1))
                                    .padding(.leading, 4)
                                }
                                if nichtErledigteA != 0 {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.systemRed)
                                    .frame(maxWidth: nichtErledigteAFloat, maxHeight: 16)
                                    .animation(Animation.easeInOut(duration: 1).delay(1.5))
                                    .padding( .horizontal, (-4 * nurNichtErledigt))
                                }
                                if aufgeschobeneA != 0 {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.systemYellow)
                                    .frame(maxWidth: aufgeschobeneAFloat, maxHeight: 16)
                                    .animation(Animation.easeInOut(duration: 1).delay(2))
                                    .padding(.trailing, 4)
                                }
                            }
                        }
                        .frame(minHeight: 24, maxHeight: 24)
                        .onAppear{
                            if (self.erledigteA == 0 || self.aufgeschobeneA == 0) {
                                self.nurNichtErledigt = CGFloat(-1)
                            }
                            self.getErledigteA()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.getNichtErledigtA()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                self.getAufgeschobeneA()
                            }
                        }
                        HStack {
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(Color(.systemBlue))
                            Text("erledigt").font(.footnote)
                            Spacer()
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(Color(.systemRed))
                            Text("abgelehnt").font(.footnote)
                            Spacer()
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(Color(.systemYellow))
                            Text("aufgeschoben").font(.footnote)
                        }
                        .padding(.horizontal)
                    }
            )
        }
    }
    /// Summiert alle Aufgaben.
    ///
    /// - Returns: Float der Summe der Aufgaben
    func sumAufgaben() -> Float {
        return Float(self.erledigteA + self.aufgeschobeneA + self.nichtErledigteA)
    }
    /// Errechnet den Anteil der erledigten Aufgaben anhand der Summe der Aufgaben und der Bildschirmbreite.
    ///
    /// - Returns: Float der Breite der erledigten Aufgaben
    func getErledigteA() {
        self.erledigteAFloat = CGFloat(Float(self.erledigteA)/sumAufgaben()*screenWidth)
        
    }
    /// Errechnet den Anteil der aufgebeschobenen Aufgaben anhand der Summe der Aufgaben und der Bildschirmbreite.
    ///
    /// - Returns: Float der Breite der aufgeschobenen Aufgaben
    func getAufgeschobeneA() {
        self.aufgeschobeneAFloat = CGFloat(Float(self.aufgeschobeneA)/sumAufgaben()*screenWidth)
    }
    /// Errechnet den Anteil der abgelehnten Aufgaben anhand der Summe der Aufgaben und der Bildschirmbreite.
    ///
    /// - Returns: Float der Breite der abgelehnten Aufgaben
    func getNichtErledigtA() {
        self.nichtErledigteAFloat = CGFloat(Float(self.nichtErledigteA)/sumAufgaben()*screenWidth)
    }
}



struct Additives_diagramm_Previews: PreviewProvider {
    static var previews: some View {
        Additives_diagramm(erledigteA: 5,nichtErledigteA: 1,aufgeschobeneA: 2)
    }
}
