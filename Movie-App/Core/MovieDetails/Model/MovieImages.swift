//
//  MovieImages.swift
//  Movie-App
//
//  Created by ayman on 08/01/2024.
//

import Foundation
struct MovieImages:Decodable{
    let backdrops : [ImageData]
    let id: Int
    let logos : [ImageData]
    let posters  : [ImageData]
    
    
    
}

struct ImageData: Decodable  {
    let file_path :String
}
