//
//  MovieDetailsVM.swift
//  Movie-App
//
//  Created by ayman on 08/01/2024.
//


import Foundation
class MovieDetailsVM {
    let MovieElement : result
    @Published var movieImages : MovieImages?
    init(MovieElement: result) {
        self.MovieElement = MovieElement
       // self.getImages(by: MovieElement.id)
    }
    func getImages(by id : Int){
       // DispatchQueue.global().async {
            UrlEndPoints.movieId = id
            NetworkManger.sharedApi.getData(url: UrlEndPoints.ImagesFetch, decodingModel: MovieImages.self) { result  in
                switch result  {
                case .success(let images):
                    print("feetched")
                    self.movieImages = images
                case.failure(let error ):
                    print("Cant feetch the image \(error)")
                }
            }
        //}
    }
}
