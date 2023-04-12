//
//  ContentView.swift
//  MovieFan
//
//  Created by Rolan on 9/4/22.
//

import SwiftUI
import Charts
import CoreData
import Combine

struct MoviesView: View {
    @EnvironmentObject var viewModel: MoviesViewModel
    
    var body: some View {
        TabView {
            List {
                Section(header: Text("Popular Movies")) {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailsView(movie: movie)) {
                            MovieCardView(movie: movie)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.getMovies()
                
                let lastDate = UserDefaults.standard.value(forKey: "lastAppearedDate")
                print("lastDate = \(lastDate)")
                
                UserDefaults.standard.setValue(Date(),
                                               forKey: "lastAppearedDate")
            }
            .tabItem{
                Label("Movies",
                systemImage: "popcorn.fill")
            }
            Chart {
                ForEach(viewModel.movieRatings.prefix(10)) { movie in
                    RectangleMark(
                        x: .value("Movie",
                                  movie.title),
                        y: .value("Vote Average",
                                  movie.voteAverage),
                        width: .ratio(0.6),
                        height: 3
                    )

                    BarMark(
                        x: .value("Movie",
                                  movie.title),
                        yStart: .value("Vote Min",
                                       movie.minVote()),
                        yEnd: .value("Vote Max",
                                     movie.maxVote())
                        ,
                        width: .ratio(0.7)
                    )
                    .opacity(0.3)
                }
                .foregroundStyle(.gray.opacity(0.5))
                RuleMark(
                    y: .value("Average",
                              viewModel.getMovieRatingsVoteAverage())
                )
                .lineStyle(StrokeStyle(lineWidth: 2))
                .annotation(position: .top,
                            alignment: .leading) {
                    Text("Test:  \(viewModel.getMovieRatingsVoteAverage(), format: .number)")
                    .font(.headline)
                    .foregroundStyle(.red)
                }
            }
            .chartYScale(domain: 0...35)
            .chartYAxis {
                AxisMarks(preset: .extended,
                          position: .leading)
            }
//            .chartXAxis(.hidden)
//            .chartYAxis(.hidden)
//            .chartLegend(.hidden)
            .chartPlotStyle { plotArea in
                plotArea
                    .frame(height: 500)
                    .background(.green.opacity(0.1))
                    .border(.pink,
                            width: 1)
            }
            .onAppear {
                viewModel.getMovieRatings()
            }
            .padding(15)
            .tabItem {
                Label("Ratings",
                      systemImage: "chart.bar")
            }
        }
        .navigationTitle("Movies")
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
            .environmentObject(MoviesViewModel())
    }
}
