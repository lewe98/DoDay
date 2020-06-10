//
//  NavigationConfigurator.swift
//  iTask
//
//  Created by Lewe Lorenzen on 10.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//
// if use: https://stackoverflow.com/questions/56505528/swiftui-update-navigation-bar-title-color
/*
 struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Don't use .appearance()!")
            }
            .navigationBarTitle("Try it!", displayMode: .inline)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .blue
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
        }
    .navigationViewStyle(StackNavigationViewStyle())
    }
}
*/
import Foundation
import SwiftUI
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}
