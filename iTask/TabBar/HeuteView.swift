//
//  HeuteView.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct HeuteView: View {
    @EnvironmentObject var coreDataFunctions: CoreDataFunctions
    @State var aufgabenView = -1
    
    @State var aufgabenGeladen = false
    
    init() {
        // UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]
        // UINavigationBar.appearance().titleTextAttributes = [.strokeColor: UIColor .systemGroupedBackground]
        UINavigationBar.appearance().backgroundColor =  UIColor.systemGroupedBackground
        
    }
    
    var body: some View {
        switch aufgabenView {
            
        case 1:
            return AnyView(
                NavigationView {
                    AktuellFirstView()
                    .navigationBarTitle(Text("Hey " + self.coreDataFunctions.curUser.nutzername + "!" ))
                    .navigationBarHidden(false)
                }
            )
            .onAppear{
                self.reload()
            }
            
        case 2:
            return
                AnyView(
                NavigationView {
                    AktuellSecondView()
                    .navigationBarTitle(Text("Aktuell"))
                }.background(Color(UIColor .systemGroupedBackground))
            ).onAppear{
                self.reload()
            }
        case 3:
            return
                AnyView(
                NavigationView {
                    Text("Nicht genügend Aufgaben in der Datenbank!")
                    .navigationBarTitle(Text("Aktuell"))
                }.background(Color(UIColor .systemGroupedBackground))
            ).onAppear{
                self.reload()
            }
        default:
            return
                AnyView(
                    ActivityIndicator()
                ).onAppear{
                    self.SetAufgabeForView()
            }
        }
    }
    func reload(){
            self.aufgabenGeladen = true
    }
    
    func SetAufgabeForView() {
        if (self.coreDataFunctions.curUser.aufgabe >= 0) {
            self.aufgabenView = 2
        } else {
            self.aufgabenView = 1
        }
        print("SetAufgabenView: ", self.aufgabenView)

    }
}



struct HeuteView_Previews: PreviewProvider {
    static var previews: some View {
        HeuteView()
    }
}
