//
//  MovieFanApp.swift
//  MovieFan
//
//  Created by Rolan on 9/4/22.
//

import SwiftUI

@main
struct MovieFanApp: App {
    let viewModel = MoviesViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MoviesView()
                    .environmentObject(viewModel)  
            }
        }
    }
}
