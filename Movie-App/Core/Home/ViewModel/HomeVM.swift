//
//  HomeVM.swift
//  Movie-App
//
//  Created by ayman on 05/01/2024.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class HomeVM{
    private var disposeBag =  DisposeBag()
    var MoviesData = BehaviorRelay<[result]>(value: [])
    @Published var MoviesFetchError : ApiError?
    var sortOption : UrlEndPoints = .TopRated
    var currantPage : Int = 1
    var totaPages :Int?
    
    
    func fetchMovies(page: Int = 1){
        UrlEndPoints.page = page
        NetworkManger.sharedApi.getData(url: sortOption, decodingModel: MovieModel.self){ result in
            switch result{
            case .success(let moviesList):
//                print("Movies Fethed")
//                print(moviesList.results.first)
                self.totaPages = moviesList.totalPages
                self.MoviesData.accept(self.MoviesData.value+moviesList.results)
            case.failure(let error ):
             
                self.MoviesFetchError = error as? ApiError
            }
        }
    }
    
    
   
    
}
 
