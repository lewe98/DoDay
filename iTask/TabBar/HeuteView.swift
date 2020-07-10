//
//  HeuteView.swift
//  DoDay
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 28.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct HeuteView: View {
    
    @EnvironmentObject var coreDataFunctions: CoreDataFunctions
    @EnvironmentObject var globalFunctions: GlobalFunctions
    
    @State var aufgabenGeladen = false
    
    init() {
        UINavigationBar.appearance().backgroundColor =  UIColor.systemGroupedBackground
    }
    
    
    
    var body: some View {
        switch coreDataFunctions.aufgabenView {
            
            
        case 1:
            return AnyView(
                NavigationView {
                    AktuellFirstView()
                        .navigationBarTitle(Text("Hey " + self.coreDataFunctions.curUser.nutzername + "!"))
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
                    .navigationBarTitle(Text("Hey " + self.coreDataFunctions.curUser.nutzername + "!"))
                }.background(Color(UIColor .systemGroupedBackground))
            ).onAppear{
                self.reload()
            }
               
            
            
        case 3:
            return
                AnyView(
                NavigationView {
                    Text("""
Datenbankfehler:
Melde dich bei einem Admin.
Grund 1:
    Nicht genügend Aufgaben in der Datenbank.
Grund 2:
    Aufgabe in Firebase auf 0 gesetzt.
""")
                    .navigationBarTitle(Text("Hey " + self.coreDataFunctions.curUser.nutzername + "!"))
                }.background(Color(UIColor .systemGroupedBackground))
            ).onAppear{
                self.reload()
            }
              
            
        default:
            return
                AnyView(
                    ActivityIndicator()
                ).onAppear{
                    
                    self.coreDataFunctions.setHeuteView()
                }
        }
    }
    
    
    func reload() {
        self.aufgabenGeladen = true
    }
}


/*
struct HeuteView_Previews: PreviewProvider {
    static var previews: some View {
        HeuteView()
    }
}
 */
