//
//  AktuellSecondView.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 29.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct AktuellSecondView: View {
    struct Constants {
        static let height: CGFloat = 230.0
        static let width: CGFloat = UIScreen.main.bounds.width
    }
    
    @EnvironmentObject var coreDataFunctions: CoreDataFunctions
    
    @State var aufgabe = Aufgabe(
        abgelehnt: 0,
        aufgeschoben: 0,
        ausgespielt: 0,
        autor: "",
        erledigt: 0,
        id: 0,
        kategorie: "",
        text: "loading...",
        text_detail: "loading...",
        text_dp: "loading...")
    
    @State var aufgabenGeladen = false
    @State var aufgabeErledigt = false
    /// Animiert die Aufgabe.
    @State private var scale: CGFloat = 0
    /// sind die Konfigurationen für den Konfettiregen.
    var config = EmitterConfig(emitter: Emitters.snow,
    size: CGSize(width: Constants.width, height: 1),
    shape: .line,
    position: CGPoint(x: Constants.width / 2, y: 0),
    name: "Snow",
    backgroundColor: .blue)
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Deine heutige Aufgabe:")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .padding(.top)
                AufgabeDetail(
                    aufgabenGeladen: aufgabenGeladen,
                    Aufgabe: aufgabe)
                    .scaleEffect(scale)
                    .animation(Animation.easeInOut(duration: 0.2))
                    .onAppear {
                        self.aufgabe = self.coreDataFunctions.getAufgabeByID(
                            id: self.coreDataFunctions.curUser.aufgabe) ?? Aufgabe(abgelehnt: 0, aufgeschoben: 0, ausgespielt: 0, autor: "", erledigt: 0, id: 0, kategorie: "", text: "Datenbank fehler", text_detail: "", text_dp: "")
                        self.aufgabenGeladen = true
                        self.scale = 1.05
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.scale = 0.95
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            self.scale = 1.02
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.scale = 1
                        }
                }
                
                Text("Warst du erfolgreich?")
                    .font(.system(.headline, design: .rounded))
                    .padding(.top)
            
                Button(action: {
                    playSound(sound: "success", type: "mp3")
                    self.aufgabeErledigt = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.scale = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self.coreDataFunctions.aufgabeErledigt()
                    }
                    
                }) {
                    Text("Aufgabe geschafft")
                        .frame(maxWidth: 240, minHeight: 15)
                        .font(.system(.headline, design: .rounded))
                        .padding()
                        .background(self.aufgabeErledigt ? .gray : Color.blue)
                        .cornerRadius(40)
                            .foregroundColor(.white)
                        .padding(3)
                }.disabled(self.aufgabeErledigt)
                 .padding(.top)
                
                Button(action: {
                    playSound(sound: "failure", type: "mp3")
                    self.coreDataFunctions.aufgabeAblehnen()
                }) {
                    Text("Aufgabe ablehnen")
                        //.frame(maxWidth: .infinity, minHeight: 44)
                        .frame(maxWidth: 240, minHeight: 15)
                        .font(.system(.headline, design: .rounded))
                        .padding()
                            .background(self.aufgabeErledigt ? .gray : Color.systemRed)
                        .cornerRadius(40)
                            .foregroundColor(.black)
                        .padding(3)
                    
                }
                .disabled(self.aufgabeErledigt)
                
                Button(action: {
                    playSound(sound: "later", type: "mp3")
                    self.coreDataFunctions.aufgabeAufschieben()
                }) {
                    Text("Ich verschiebe die Aufgabe")
                    .frame(maxWidth: 240, minHeight: 15)
                    .font(.system(.headline, design: .rounded))
                    .padding()
                        .background(self.aufgabeErledigt ? .gray : Color.systemYellow)
                    .cornerRadius(40)
                        .foregroundColor(.black)
                    .padding(3)
                }
                .disabled(self.aufgabeErledigt)
        
                Spacer()
            }
            if self.aufgabeErledigt {
                VStack(alignment: .leading) {
                    config.emitter
                        .emitterSize(config.size)
                        .emitterShape(config.shape)
                        .emitterPosition(config.position)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: Confetti.Constants.height,
                               maxHeight: .infinity,
                               alignment: Alignment.topLeading)
                }
               
            }
        }
            .background(Color(UIColor .systemGroupedBackground))
    }
}
