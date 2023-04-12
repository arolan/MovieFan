//
//  MovieAPI.swift
//  MovieFan
//
//  Created by Rolan on 9/4/22.
//

import Foundation
import Alamofire

typealias MovieAPIResponse = (Swift.Result<[Movie]?, DataError>) -> Void
typealias MovieRatingAPIResponse = (Swift.Result<[MovieRating]?, DataError>) -> Void

/// API interface to retrieve movies
protocol MovieAPILogic {
    func getMovies(completion: @escaping (MovieAPIResponse))
    func getMovieRatings(completion: @escaping (MovieRatingAPIResponse))
}

class MovieAPI: MovieAPILogic {
    /// Movie API URL returning list of movies with details
    private struct Constants {
        static let apiKey = "9b94de2654d82e14b60d1cc6143665af"
        static let languageLocale = "en-US"
        
        static let moviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=\(languageLocale)&page=\(pageValue)"
        
        static let movieRatingsURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=\(languageLocale)&page=\(pageValue)"
        
        static let pageValue = 1
        static let rParameter = "r"
        static let json = "json"
    }
    
    //https://image.tmdb.org/t/p/w500/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg
    
    func getMovies(completion: @escaping (MovieAPIResponse)) {
        // this prevents AF retrieving cached responses
        URLCache.shared.removeAllCachedResponses()
        
        AF.request(Constants.moviesURL,
                   method: .get,
                   encoding: URLEncoding.default)
        .validate()
        .responseDecodable(of: MovieRootResult.self) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(.networkingError(error.localizedDescription)))
            case .success(let moviesListResult):
                completion(.success(moviesListResult.movies))
            }
        }
    }
    
    func getMovieRatings(completion: @escaping (MovieRatingAPIResponse)) {
        // this prevents AF retrieving cached responses
        URLCache.shared.removeAllCachedResponses()
        
        AF.request(Constants.movieRatingsURL,
                   method: .get,
                   encoding: URLEncoding.default)
        .validate()
        .responseDecodable(of: TopRatedMovieRootResult.self) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(.networkingError(error.localizedDescription)))
            case .success(let movieRatingsResult):
                completion(.success(movieRatingsResult.topRatedMovies))
            }
        }
    }
    
}
