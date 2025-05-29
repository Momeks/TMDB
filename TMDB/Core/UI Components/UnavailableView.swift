//
//  ErrorView.swift
//  TMDB
//
//  Created by Mohammad Komeili on 29.05.25.
//

import SwiftUI

struct ErrorView: View {
    var title: String
    var action: (() -> Void)?
    
    var body: some View {
        ContentUnavailableView(label: {
            Label(title, systemImage: "exclamationmark.triangle")
        }, actions: {
            Button("refresh", systemImage: "arrow.clockwise") {
                action?()
            }
        })
    }
}

#Preview {
    ErrorView(title: "Error")
}
