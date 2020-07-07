//
//  FreundeHinzufuegenView.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 09.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct FreundeHinzufuegenView: View {
    
    let globalFunctions: GlobalFunctions
    
    @State private var freundesCode: String = ""
    
    init(gf: GlobalFunctions) {
        self.globalFunctions = gf
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    
                    Section(header: Text("FREUNDESCODE EINGEBEN")) {
                        TextField("Freundescode", text: $freundesCode)
                    }
                    
                    Section() {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.globalFunctions.callAddFriend(freundID: self.freundesCode)
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

/*
struct FreundeHinzufuegenView_Previews: PreviewProvider {
    static var previews: some View {
        FreundeHinzufuegenView()
    }
}
*/
