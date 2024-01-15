//
//  HomeCollectionViewCell.swift
//  Movie-App
//
//  Created by ayman on 05/01/2024.
//

import UIKit
import Alamofire
class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var MoviePoster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(with model : result){
       
        if let imageUrl = URL(string: "\(UrlEndPoints.imageBaseUrl)\(model.PosterPath)" ){
            self.MoviePoster?.kf.setImage(with:imageUrl , placeholder: UIImage(named: "placeHoleder"), options: [.callbackQueue(.mainAsync)]) { result  in
                switch result {
                case.success(let image ):
                    self.MoviePoster.image = image.image
                case .failure(_):
                    self.MoviePoster.image = UIImage(named: "placeHoleder")
                }
            }
            
        }
    }
}
