//
//  ErrorView.swift
//  TMDB
//
//  Created by Mohammad Komeili on 29.05.25.
//

import SwiftUI

struct ErrorView: View {
    var description: String
    var action: (() -> Void)?
    
    var body: some View {
        ContentUnavailableView(label: {
            Label("Error", systemImage: "exclamationmark.triangle")
        }, description: {
            Text(description)
        }, actions: {
            Button("refresh", systemImage: "arrow.clockwise") {
                action?()
            }
        })
    }
}

#Preview {
    ErrorView(description: "Error")
}
