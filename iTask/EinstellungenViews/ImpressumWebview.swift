//
//  ImpressumWebview.swift
//  iTask
//
//  Created by Julian Hermanspahn, Lewe Lorenzen & Thomas Raab on 06.06.20.
//  Copyright © 2020 DoDay. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

struct ImpressumWebview: UIViewRepresentable {
    
    /// Die URL, die das Impressum beinhaltet.
    var url = "https://info.frag-was-neues.de/impressum.html"
    
    /// Generiert ein Modalfenster, welches den Webcontent der URL (Impressum) in der App einbettet.
    ///
    /// - Parameter value: context
    /// - Returns: WKWebView, die den Inhalt der URL (Impressum) enthält
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        
        let request = URLRequest(url: url)
        let wkWebview = WKWebView()
        wkWebview.load(request)
        return wkWebview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
