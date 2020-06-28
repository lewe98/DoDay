//
//  additives_diagramm.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 30.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI

struct Additives_diagramm: View {
    var erledigteA: Int
    var nichtErledigteA: Int
    var aufgeschobeneA: Int
    
    var body: some View {
        ZStack(alignment: .leading){
           

            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color(UIColor .secondarySystemFill))
                .frame(maxWidth: 400, maxHeight: 24)
                //.overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke( lineWidth: 2))
            HStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.green)
                .frame(maxWidth: CGFloat(getErledigteA()), maxHeight: 16)
                    .padding(.leading, 4)
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.red)
                .frame(maxWidth: CGFloat((getNichtErledigtA())), maxHeight: 16)
                    .padding( .horizontal, -4)
                
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.yellow)
                .frame(maxWidth: CGFloat(getAufgeschobeneA()), maxHeight: 16)
                    .padding(.trailing ,4)
            }
        }
    }
    
    func sumAufgaben() -> Float {
        return Float(self.erledigteA + self.aufgeschobeneA + self.nichtErledigteA)
    }
    func getErledigteA() -> Float {
        return (Float(self.erledigteA)/sumAufgaben()*400)
        
    }
    func getAufgeschobeneA() -> Float {
        return (Float(self.aufgeschobeneA)/sumAufgaben()*400)
    }
    func getNichtErledigtA() -> Float {
        return (Float(self.nichtErledigteA)/sumAufgaben()*400)
    }
}



struct Additives_diagramm_Previews: PreviewProvider {
    static var previews: some View {
        Additives_diagramm(erledigteA: 5,nichtErledigteA: 1,aufgeschobeneA: 2)
    }
}
