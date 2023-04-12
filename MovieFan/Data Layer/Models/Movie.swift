//
//  Movie.swift
//  MovieFan
//
//  Created by Rolan on 9/5/22.
//

import Foundation

struct MovieRootResult: Codable {
    let page: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
    }
}

struct Movie: Codable, Identifiable {
    struct Constants {
        static let baseImageUrl = "https://image.tmdb.org/t/p/"
        static let logoSize = "w45"
        static let largeImageSize = "w500"
    }
    
    var id: Int
    let title: String
    let releaseDate: String
    let imageUrlSuffix: String
    let overview: String
    
    func getThumbnailImageUrl() -> String {
        return "\(Constants.baseImageUrl)\(Constants.logoSize)\(imageUrlSuffix)"
    }
    
    func getLargeImageUrl() -> String {
        return "\(Constants.baseImageUrl)\(Constants.largeImageSize)\(imageUrlSuffix)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case overview
        case imageUrlSuffix = "poster_path"
    }
}
