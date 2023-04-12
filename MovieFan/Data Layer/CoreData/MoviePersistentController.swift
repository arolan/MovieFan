//
//  MoviePersistentController.swift
//  MovieFan
//
//  Created by Rolan Marat on 1/1/23.
//

import Foundation
import CoreData

class MoviePersistentController: ObservableObject {
    var persistentContainer = NSPersistentContainer(name: "MovieFan")
    private var moviesFetchRequest = MovieCD.fetchRequest()
    private var movieRatingFetchRequest = MovieRatingCD.fetchRequest()
    
    init() {
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("error = \(error)")
            }
        }
    }
    
    func updateAndAddMovieServerDataToCoreData(moviesFromBackend: [Movie]?) {
        // 0. prepare incoming server side movies ID list and dictionary
        var moviesIdDict: [Int: Movie] = [:]
        var moviesIdList: [Int] = []
        
        guard let movies = moviesFromBackend,
              !movies.isEmpty else {
            return
        }
        
        for movie in movies {
            moviesIdDict[movie.id] = movie
        }
        moviesIdList = movies.map { $0.id }
        
        // 1. get all movies that match incoming server side movie ids
        // find any existing movies in our local CoreData
        moviesFetchRequest.predicate = NSPredicate(
            format: "id IN %@", moviesIdList
        )
        
        // 2. make a fetch request using predicate
        let managedObjectContext = persistentContainer.viewContext
        
        let moviesCDList = try? managedObjectContext.fetch(moviesFetchRequest)
        print("moviesCDList = \(moviesCDList)")
        
        guard let moviesCDList = moviesCDList else {
            return
        }
        
        var moviesIdListInCD: [Int] = []
        
        // 3. update all matching movies from CoreData to have the same data
        // server side movies
        for movieCD in moviesCDList {
            moviesIdListInCD.append(Int(movieCD.id))
            
            if let movie = moviesIdDict[Int(movieCD.id)] {
                movieCD.setValue(movie.overview,
                                 forKey: "overview")
                movieCD.setValue(movie.title,
                                 forKey: "title")
                movieCD.setValue(movie.imageUrlSuffix,
                                 forKey: "imageUrlSuffix")
                movieCD.setValue(movie.releaseDate,
                                 forKey: "releaseDate")
            }
        }
        
        // 4. add new objects coming from the backend/server side
        for movie in movies {
            if !moviesIdListInCD.contains(movie.id) {
                let genreCD = GenreCD(context: managedObjectContext)
                genreCD.id = 1
                genreCD.title = "Comedy"
                
                let movieCD = MovieCD(context: managedObjectContext)
                movieCD.id = Int64(movie.id)
                movieCD.overview = movie.overview
                movieCD.releaseDate = movie.releaseDate
                movieCD.imageUrlSuffix = movie.imageUrlSuffix
                movieCD.genre = genreCD
            }
        }
        
        // 5. save changes
        try? managedObjectContext.save()
    }
    
    func updateAndAddMovieRatingServerDataToCoreData(movieRatingFromBackend: [MovieRating]?) {
        // 0. prepare incoming server side movie rating ID list and dictionary
        var movieRatingsIdDict: [Int: MovieRating] = [:]
        var movieRatingsIdList: [Int] = []
        
        guard let movieRatings = movieRatingFromBackend,
              !movieRatings.isEmpty else {
            return
        }
        
        for movieRating in movieRatings {
            movieRatingsIdDict[movieRating.id] = movieRating
        }
        movieRatingsIdList = movieRatings.map { $0.id }
        
        // 1. get all movie ratings that match incoming server side movie rating ids
        // find any existing movie ratings in our local CoreData
        movieRatingFetchRequest.predicate = NSPredicate(
            format: "id IN %@", movieRatingsIdList
        )
        
        // 2. make a fetch request using predicate
        let managedObjectContext = persistentContainer.viewContext
        
        let movieRatingsCDList = try? managedObjectContext.fetch(movieRatingFetchRequest)
        print("movieRatingsCDList = \(movieRatingsCDList)")
        
        guard let movieRatingsCDList = movieRatingsCDList else {
            return
        }
        
        var movieRatingsIdListInCD: [Int] = []
        
        // 3. update all matching movies from CoreData to have the same data
        // server side movies
        for movieRatingCD in movieRatingsCDList {
            movieRatingsIdListInCD.append(Int(movieRatingCD.id))
            
            if let movieRating = movieRatingsIdDict[Int(movieRatingCD.id)] {
                movieRatingCD.setValue(movieRating.popularity,
                                       forKey: "popularity")
                movieRatingCD.setValue(movieRating.title,
                                       forKey: "title")
                movieRatingCD.setValue(movieRating.voteAverage,
                                       forKey: "voteAverage")
                movieRatingCD.setValue(movieRating.voteCount,
                                       forKey: "voteCount")
            }
        }
        
        // 4. add new objects coming from the backend/server side
        for movieRating in movieRatings {
            if !movieRatingsIdListInCD.contains(movieRating.id) {
                let movieRatingCD = MovieRatingCD(context: managedObjectContext)
                movieRatingCD.id = Int64(movieRating.id)
                movieRatingCD.popularity = movieRating.popularity
                movieRatingCD.voteCount = Int64(movieRating.voteCount)
                movieRatingCD.voteAverage = movieRating.voteAverage
            }
        }
        
        // 5. save changes
        try? managedObjectContext.save()
    }
    
    func fetchMoviesFromCoreData() -> [Movie] {
        
        let movieTitleSortDescriptor = NSSortDescriptor(key: "title",
                                                   ascending: false)
        let movieReleaseDateSortDescriptor = NSSortDescriptor(key: "releaseDate", ascending: true)
        moviesFetchRequest.sortDescriptors = [movieReleaseDateSortDescriptor]
        
        
        let moviesCDList = try? persistentContainer.viewContext.fetch(moviesFetchRequest)
        var convertedMovies: [Movie] = []
        
        guard let moviesCDList = moviesCDList else {
            return []
        }
        
        for movieCD in moviesCDList {
            let movie = Movie(id: Int(movieCD.id),
                              title: movieCD.title ?? "",
                              releaseDate: movieCD.releaseDate ?? "",
                              imageUrlSuffix: movieCD.imageUrlSuffix ?? "",
                              overview: movieCD.overview ?? "")
            convertedMovies.append(movie)
        }
        
        return convertedMovies
    }
    
    func fetchMovieRatingsFromCoreData() -> [MovieRating] {
        
        let movieRatingVoteCountSortDescriptor = NSSortDescriptor(key: "voteCount",
                                                                  ascending: true)
        movieRatingFetchRequest.sortDescriptors = [movieRatingVoteCountSortDescriptor]
        
        let movieRatingsCDList = try? persistentContainer.viewContext.fetch(movieRatingFetchRequest)
        
        var convertedMovieRatings: [MovieRating] = []
        
        guard let movieRatingsCDList = movieRatingsCDList else {
            return []
        }
        
        for movieRatingCD in movieRatingsCDList {
            let movieRating = MovieRating(id: Int(movieRatingCD.id),
                                          title: movieRatingCD.title ?? "",
                                          popularity: movieRatingCD.popularity,
                                          voteCount: Int(movieRatingCD.voteCount),
                                          voteAverage: movieRatingCD.voteAverage)
            convertedMovieRatings.append(movieRating)
        }
        
        return convertedMovieRatings
    }
}
