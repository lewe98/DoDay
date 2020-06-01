//
//  HeuteView.swift
//  iTask
//
//  Created by Thomas on 28.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct HeuteView: View {
    var aufgabeInArbeit = false
    var body: some View {
        switch aufgabeInArbeit {
        case true:
            return AnyView(
                NavigationView {
                   AktuellFirstView(Aufgabe1: "Sprich mit einer dir fremden Person", Aufgabe2: "Gehe 10.000 Schritte Zu Fuß")
                    .navigationBarTitle(Text("Aktuell"))
                }
            )
        case false:
            return
                AnyView(
                NavigationView {
                   AktuellSecondView(Aufgabe: "Sprich mit einer dir fremden Person")
                    .navigationBarTitle(Text("Aktuell"))
                }
            )
        }
    }
}

struct HeuteView_Previews: PreviewProvider {
    static var previews: some View {
        HeuteView()
    }
}
