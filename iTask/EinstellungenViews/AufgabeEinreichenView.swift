//
//  AufgabeEinreichenView.swift
//  iTask
//
//  Created by Thomas on 06.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct AufgabeEinreichenView: View {
    @State private var aufgabe: String = ""
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section(header: Text("DEINE AUFGABE")) {
                        TextField("Sprich mit einer dir fremden Person", text: $aufgabe)
                    }
                
                    Section() {
                        HStack {
                            Spacer()
                            Button(action: {
                                // TODO: Funktion einfuegen
                                print(self.aufgabe)
                            }) {
                                Text("Abschicken")
                                    .foregroundColor(.green)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .navigationBarTitle(Text("Aufgabe einreichen"))
        }
    }
}

struct AufgabeEinreichenView_Previews: PreviewProvider {
    static var previews: some View {
        AufgabeEinreichenView()
    }
}

