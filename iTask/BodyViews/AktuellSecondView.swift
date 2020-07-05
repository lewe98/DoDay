//
//  AktuellSecondView.swift
//  iTask
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
    @State private var scale: CGFloat = 0
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
                Text("Du hast dir für heute folgende Aufgabe ausgesucht.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(20)
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
                
                Text("Konntest du die Aufgabe erfolgreich erledigen?")
                    .font(.footnote)
                    .padding()
            
                Button(action: {
                    playSound(sound: "applause", type: "mp3")
                    self.aufgabeErledigt = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.scale = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self.coreDataFunctions.aufgabeErledigt()
                    }
                    
                }) {
                    Text("Ja")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .background(Color(.tertiarySystemBackground))
                .border(Color.gray, width: 0.2)
                .padding(.top)
                
                Button(action: {
                    self.coreDataFunctions.aufgabeAblehnen()
                }) {
                    Text("Nein")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .foregroundColor(.red)
                .background(Color(.tertiarySystemBackground))
                .border(Color.gray, width: 0.2)
                .padding(.top)
                
                Button(action: {
                    self.coreDataFunctions.aufgabeAufschieben()
                }) {
                    Text("Ich verschiebe die Aufgabe")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .background(Color(.tertiarySystemBackground))
                .border(Color.gray, width: 0.2)
                .padding(.top)
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
                //.scaleEffect(self.aufgabeErledigt ? 1 : 0)
                //.opacity(self.aufgabeErledigt ? 1.0 : 0.0)
                //.animation(.easeIn(duration: 1))
            }
        }
            .background(Color(UIColor .systemGroupedBackground))
    }
}

/*

struct AktuellSecondView_Previews: PreviewProvider {
    static var previews: some View {
        AktuellSecondView(aufgabenGeladen: true, Aufgabe: "Mache das!")
    }
}
*/
