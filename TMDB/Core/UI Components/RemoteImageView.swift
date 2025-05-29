//
//  RemoteImageView.swift
//  TMDB
//
//  Created by Mohammad Komeili on 29.05.25.
//

import SwiftUI

struct RemoteImageView: View {
    let url: URL?
    let animationDuration: Double = 0.3
    
    @State private var isImageLoaded = false
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .opacity(isImageLoaded ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeIn(duration: animationDuration)) {
                            isImageLoaded = true
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            case .failure:
                Image(systemName: "photo.trianglebadge.exclamationmark")
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 1.1)
                            .frame(width: 120, height: 180)
                    }
                    .foregroundColor(.secondary)
                
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    let imageURL = "https://image.tmdb.org/t/p/w440_and_h660_face/yFHHfHcUgGAxziP1C3lLt0q2T4s.jpg"
    
    RemoteImageView(url: URL(string: imageURL)!)
        .frame(width: 120, height: 180)
}
