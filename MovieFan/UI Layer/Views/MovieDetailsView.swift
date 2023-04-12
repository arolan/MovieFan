//
//  MovieDetailsView.swift
//  MovieFan
//
//  Created by Rolan on 9/5/22.
//

import SwiftUI

struct MovieDetailsView: View {
    var movie: Movie
    var body: some View {
        ScrollView {
            VStack {
                let url = URL(string: movie.getLargeImageUrl())
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 350,
                               height: 350,
                               alignment: .center)
                } placeholder: {
                    Image("blue_square")
                        .resizable()
                        .frame(width: 250, height: 250)
                }
                Spacer()
                Text("Released: \(movie.releaseDate)")
                Spacer()
                Text(movie.overview)
                    .font(.body)
                    .foregroundColor(.black)
            }
            .accessibilityLabel("Movie Details")
        }
        .navigationTitle(movie.title)
        .foregroundColor(.blue)
        .padding()
        
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Movie(id: 1,
                                      title: "Terminator 2",
                                      releaseDate: "1997-10-01",
                                      imageUrlSuffix: "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg",
                                      overview: "Terminator T-100 and the rest of the crew fight for the future of humanity"))
    }
}
