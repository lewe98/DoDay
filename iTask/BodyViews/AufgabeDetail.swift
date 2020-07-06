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
    @State private var wobble = true
    @State private var detailText = false
    @State private var statistik = false
    @State private var animateDetailText = false
    @State private var animateStatistik = false

    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 40)
                .shadow(color: .gray, radius: 20, x: 0, y: 5)
                .foregroundColor(Color(.tertiarySystemBackground))
            
                
                //.foregroundColor(Color(UIColor .secondarySystemFill))
            if (aufgabenGeladen) {
                ZStack {
                    VStack {
                        Text(self.Aufgabe.kategorie)
                            .font(.system(.footnote, design: .rounded))
                            .padding(.bottom, 4)
                        Text(Aufgabe.text)
                            .fontWeight(.bold)
                            .font(.system(.headline, design: .rounded))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.blue)
                    }
                        .padding(10).opacity(detailText || statistik ? 0.0 : 1.0)
                    Text(Aufgabe.text_detail)
                        .fontWeight(.bold)
                        .font(.system(.footnote, design: .rounded))
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .opacity(detailText ? 1.0 : 0.0)
                        .padding(15)
                    VStack {
                        Text("Wie erfolgreich waren andere mit der Aufgabe:")
                        .font(.system(.footnote, design: .rounded))
                        .padding(.bottom, 4)
                        Additives_diagramm(
                            erledigteA: self.Aufgabe.erledigt,
                            nichtErledigteA: self.Aufgabe.abgelehnt,
                            aufgeschobeneA: self.Aufgabe.aufgeschoben)
                            .frame(minHeight: 24, maxHeight: 24)
                        HStack {
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(.green)
                            Text("erledigt").font(.footnote)
                            Spacer()
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(.red)
                            Text("nicht erledigt").font(.footnote)
                            Spacer()
                            Circle()
                                .frame(maxWidth: 12, maxHeight: 12)
                                .foregroundColor(.yellow)
                            Text("aufgeschoben").font(.footnote)
                        }
                    }
                    .padding(.horizontal)
                    .opacity(statistik ? 1.0 : 0.0)
                    HStack {
                        Spacer()
                        VStack {
                            if (!statistik) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue)
                                        
                                    Image(systemName: "info")
                                        .font(.system(size: 20.0))
                                        .foregroundColor(.white)
                                        .opacity(detailText ? 0.0 : 1.0)
                                    Image(systemName: "xmark")
                                        .font(.system(size: 20.0))
                                        .foregroundColor(.white)
                                        .opacity(detailText ? 1.0 : 0.0)
                                }
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    withAnimation(Animation.linear(duration: 0.8)) {
                                        self.animateDetailText.toggle()
                                    }
                                }
                            }
                            Spacer()
                            if (!detailText) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue)
                                        
                                    Image(systemName: "chart.bar")
                                        .font(.system(size: 15.0))
                                        .foregroundColor(.white)
                                        .opacity(statistik ? 0.0 : 1.0)
                                    Image(systemName: "xmark")
                                    .font(.system(size: 20.0))
                                    .foregroundColor(.white)
                                    .opacity(statistik ? 1.0 : 0.0)
                                }
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    withAnimation(Animation.linear(duration: 0.8)) {
                                        self.animateStatistik.toggle()
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
            } else {
                ActivityIndicator()
            }
            
            }.frame(height: 150)
            .padding()
            .animation(.default)
            .modifier(FlipDetailText(flipped: $detailText, angle: animateDetailText ? 180 : 0, axis: (x: 1, y: 0)))
            .modifier(FlipStatistik(flipped: $statistik, angle: animateStatistik ? 180 : 0, axis: (x: 1, y: 0)))
            
            //.scaleEffect(showDetail ? 1.5 : 1)
            .onAppear() {
            }

    }
}

struct FlipDetailText: GeometryEffect {

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
struct FlipStatistik: GeometryEffect {

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
