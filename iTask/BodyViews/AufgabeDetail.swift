//
//  AufgabeDetail.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 29.05.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct AufgabeDetail: View {
    let aufgabenGeladen: Bool
    let Aufgabe: Aufgabe
    @State private var scale: CGFloat = 0.8
    @State private var showDetail = false
    @State private var wobble = true
    @State private var flipped = false
    @State private var animate3d = false
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 40)
                .shadow(color: .gray, radius: 20, x: 0, y: 5)
                .foregroundColor(.white)
            
                
                //.foregroundColor(Color(UIColor .secondarySystemFill))
            if (aufgabenGeladen) {
                ZStack {
                    Text(Aufgabe.text)
                        .fontWeight(.bold)
                        .font(.system(.headline, design: .rounded))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.blue)
                        // .font(.system(size: 25))
                        .padding(10).opacity(flipped ? 0.0 : 1.0)
                Text(Aufgabe.text_detail).opacity(flipped ? 1.0 : 0.0)
                }
            } else {
                ActivityIndicator()
            }
            Image(systemName: "info").backgroundColor(.blue)
                .position(x: .infinity, y: .infinity)
                .onTapGesture {
                  withAnimation(Animation.linear(duration: 0.8)) {
                        self.animate3d.toggle()
                  }
            }
            }.frame(height: 150)
            .padding()
            .animation(.default)
            .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 1, y: 0)))
            
            //.scaleEffect(showDetail ? 1.5 : 1)
            .onAppear() {
                self.showDetail.toggle()
                
            }

    }
}
struct FlipEffect: GeometryEffect {

      var animatableData: Double {
            get { angle }
            set { angle = newValue }
      }

      @Binding var flipped: Bool
      var angle: Double
      let axis: (x: CGFloat, y: CGFloat)

      func effectValue(size: CGSize) -> ProjectionTransform {

            DispatchQueue.main.async {
                  self.flipped = self.angle >= 90 && self.angle < 270
            }

            let tweakedAngle = flipped ? -180 + angle : angle
            let a = CGFloat(Angle(degrees: tweakedAngle).radians)

            var transform3d = CATransform3DIdentity;
            transform3d.m34 = -1/max(size.width, size.height)

            transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
            transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

            let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

            return ProjectionTransform(transform3d).concatenating(affineTransform)
      }
}

/*
struct AufgabeDetail_Previews: PreviewProvider {
    static var previews: some View {
        AufgabeDetail(aufgabenGeladen: true, Aufgabe: "Gib Jemandem ein Kompliment.")
    }
}
*/
