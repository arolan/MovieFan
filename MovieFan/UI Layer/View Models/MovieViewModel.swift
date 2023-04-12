//
//  MovieViewModel.swift
//  MovieFan
//
//  Created by Rolan on 9/5/22.
//

import Foundation
import Combine
import Network
import CoreData

class MoviesViewModel: ObservableObject {
    private var networkConnectivity = NWPathMonitor()
    
    // Core Data
    private var persistentController: MoviePersistentController
    
    // Network/backend Service
    private let apiService: MovieAPILogic
    
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var error: DataError? = nil
    @Published private(set) var movieRatings: [MovieRating] = []
    
    init(apiService: MovieAPILogic = MovieAPI(),
         persistentController: MoviePersistentController = MoviePersistentController()) {
        self.apiService = apiService
        self.persistentController = persistentController
        networkConnectivity.start(queue: DispatchQueue.global(qos: .userInitiated))
    }
    
    func getMovies() {
        switch networkConnectivity.currentPath.status {
        case .satisfied: // connected to internet
            apiService.getMovies() { [weak self] result in
                switch result {
                case .success(let movies):
                    self?.movies = movies ?? []
                    
                    self?.persistentController.updateAndAddMovieServerDataToCoreData(moviesFromBackend: movies)
                case .failure(let error):
                    self?.error = error
                }
            }
        default: // not connected to internet
            // Fetch it from persistence of the device
            movies = persistentController.fetchMoviesFromCoreData() 
        }
    }
    
    func getMovieRatingsVoteAverage() -> Double {
        let voteAverages = movieRatings.prefix(10).map { $0.voteAverage }
        let sum = voteAverages.reduce(0, +)
        return sum / 10
    }
    
    func getMovieRatings() {
        switch networkConnectivity.currentPath.status {
        case .satisfied: // connected to internet
            apiService.getMovieRatings { [weak self] result in
                switch result {
                case .success(let movieRatings):
                    self?.movieRatings = movieRatings ?? []
                    
                    self?.persistentController.updateAndAddMovieRatingServerDataToCoreData(movieRatingFromBackend: movieRatings)
                case .failure(let error):
                    self?.error = error
                }
            }
        default: // not connected to internet
            // Fetch it from persistence of the device
            movieRatings = persistentController.fetchMovieRatingsFromCoreData()
        }
        
    }
}
