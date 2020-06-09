//
//  Register.swift
//  iTask
//
//  Created by Julian Hermanspahn on 08.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct Register: View {
    
    @ObservedObject var firebaseFunctions = FirebaseFunctions()
    @State private var vorname: String = ""
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section() {
                        TextField("Dein Vorname", text: $vorname)
                    }
                
                    Section() {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.firebaseFunctions.registerUser(id: self.uuid!, vorname: self.vorname)
                                print(self.vorname)
                            }) {
                                Text("Jetzt registrieren")
                                    .foregroundColor(.green)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .navigationBarTitle(Text("Willkommen!"))
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
