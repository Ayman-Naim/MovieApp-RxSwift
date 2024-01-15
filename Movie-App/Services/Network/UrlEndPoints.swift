//
//  UrlEndPoints.swift
//  Movie-App
//
//  Created by ayman on 04/01/2024.
//

import Foundation
enum UrlEndPoints: String ,CaseIterable {
    static private let baseURL = "https://api.themoviedb.org/3/movie/"
    static  let imageBaseUrl = "https://image.tmdb.org/t/p/w185//"
    static  var page = 1
    static var movieId : Int?
    case TopRated
    case MostPopular
    case ImagesFetch
    var Url:String {
        switch self{
        case.MostPopular  : return "\(UrlEndPoints.baseURL)popular?&page=\(UrlEndPoints.page)"
        case.TopRated : return "\(UrlEndPoints.baseURL)top_rated?&page=\(UrlEndPoints.page)"
        case.ImagesFetch : return "\(UrlEndPoints.baseURL)\(UrlEndPoints.movieId!)/images"
        }
    }
}
