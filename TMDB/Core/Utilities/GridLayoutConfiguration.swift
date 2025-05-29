//
//  GridLayoutConfiguration.swift
//  TMDB
//
//  Created by Mohammad Komeili on 29.05.25.
//

import Foundation

struct GridLayoutConfiguration {
    let compactColumns: Int
    let regularColumns: Int
    let spacing: CGFloat
    
    static let `default` = GridLayoutConfiguration(
        compactColumns: 2,
        regularColumns: 4,
        spacing: 16
    )
}
