//
//  MovieCardView.swift
//  MovieFan
//
//  Created by Rolan on 9/5/22.
//

import SwiftUI

struct MovieCardView: View {
    var movie: Movie
    var body: some View {
        VStack {
            HStack {
                Text(movie.title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
                let url = URL(string: movie.getThumbnailImageUrl())
                AsyncImage(url: url) { image in
                    image.scaledToFit()
                } placeholder: {
                    Image("blue_square")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            HStack {
                Text(movie.releaseDate)
                    .font(.caption)
                    .foregroundColor(.accentColor)
                Spacer()
            }
        }
        .padding()
    }
}

struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCardView(movie: Movie(id: 1,
                                   title: "Terminator 2",
                                   releaseDate: "1997-10-01",
                                   imageUrlSuffix: "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg",
                                   overview: "Terminator T-100 and the rest of the crew fight for the future of humanity"))
    }
}
