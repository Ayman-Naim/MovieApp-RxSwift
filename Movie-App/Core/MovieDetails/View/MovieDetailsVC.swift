//
//  MovieDetailsVC.swift
//  Movie-App
//
//  Created by ayman on 07/01/2024.
//

import UIKit
import Cosmos
import Kingfisher
import Combine
class MovieDetailsVC: UIViewController {
    
    @IBOutlet weak var moviePoster1: UIImageView!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var moviePoster2: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRate: CosmosView!
    @IBOutlet weak var movieOverView: UILabel!
    
    
    var viewModel :MovieDetailsVM?
    private var cancellables : Set<AnyCancellable> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Details "
        navigationController?.navigationBar.tintColor = UIColor.white
      
        setupView()
        viewModel!.getImages(by: viewModel!.MovieElement.id)
        
        
    }
    
    // setup the page outlets
    func setupView(){
        viewModel!.$movieImages.receive(on: DispatchQueue.main).sink{[weak self] value in
            self!.movieOverView?.text = self!.viewModel!.MovieElement.overView
            self!.movieTitle?.text = self!.viewModel!.MovieElement.title
            self!.movieReleaseDate?.text = self!.viewModel!.MovieElement.releaseDate
            self!.movieRate?.rating = Double(self!.viewModel!.MovieElement.movieRating/2.0)
            self!.setImag(url: self!.viewModel!.MovieElement.PosterPath , imagView: self!.moviePoster1)
            self!.setImag(url: value?.backdrops.last?.file_path ?? "", imagView: self!.moviePoster2)
            
            
        }.store(in: &cancellables)
        
    }
    
    
    // set image to  image views
    func setImag(url imagesUrl : String,imagView:UIImageView){
        
        if let imageUrl = URL(string: "\(UrlEndPoints.imageBaseUrl)\(imagesUrl)" ){
            imagView.kf.setImage(with:imageUrl , placeholder: UIImage(named: "placeHoleder"),options: [.callbackQueue(.mainAsync)])
            
        }
    }
    
 
}
