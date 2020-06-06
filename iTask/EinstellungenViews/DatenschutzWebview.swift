//
//  DatenschutzWebview.swift
//  iTask
//
//  Created by Thomas on 06.06.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

struct DatenschutzWebview: UIViewRepresentable {
    
    var url = "https://ersteweltprobleme.com/einsenden/datenschutz.html"
    
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
