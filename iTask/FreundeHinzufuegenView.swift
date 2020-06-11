//
//  FreundeHinzufuegenView.swift
//  iTask
//
//  Created by Thomas on 09.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct FreundeHinzufuegenView: View {
    @State private var freundesCode: String = ""
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section(header: Text("FREUNDESCODE EINGEBEN")) {
                        TextField("BeiSP1eL", text: $freundesCode)
                    }
                
                    Section() {
                        HStack {
                            Spacer()
                            Button(action: {
                                // TODO: Funktion einfuegen
                                print(self.freundesCode)
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
            .navigationBarTitle(Text("Freund hinzufügen"))
        }
    }
}

struct FreundeHinzufuegenView_Previews: PreviewProvider {
    static var previews: some View {
        FreundeHinzufuegenView()
    }
}
