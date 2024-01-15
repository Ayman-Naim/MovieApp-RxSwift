//
//  MovieModel.swift
//  Movie-App
//
//  Created by ayman on 05/01/2024.
//

import Foundation
struct MovieModel:Decodable {
    let page : Int
    let results: [result]
    let totalPages,totalResults : Int
    
    
    enum CodingKeys: String ,CodingKey {
        case page , results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        
    }
    
    
}
struct result : Decodable {
    let adult: Bool
    let id: Int
    let originalTitle:String
    let overView : String
    let popularity: Double
    let PosterPath: String
    let releaseDate: String
    let title : String
    let movieRating:Double
    enum CodingKeys : String ,CodingKey{
        case adult
        case id
        case originalTitle = "original_title"
        case overView = "overview"
        case popularity
        case PosterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case movieRating = "vote_average"
    }
    
}
