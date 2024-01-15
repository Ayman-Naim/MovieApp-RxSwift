//
//  NetworkManger.swift
//  Movie-App
//
//  Created by ayman on 04/01/2024.
//

import Foundation
import RxSwift
import Alamofire
class NetworkManger{
    static let sharedApi = NetworkManger()
    
    private init() {}
    
    private let headerApi : HTTPHeaders = [
        "Authorization" : "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZDQ4ZDY1N2VlNTY4YmY3Y2JkYmU1YTg0MTk4ZjQ4ZSIsInN1YiI6IjY1OTVhZDI4MGU2NGFmNTY5MzhjMTkwYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ALEWr8cESXRJ5Jr_1S21srYSeLEJ_XR2RbKLCjKw2dU",
        "accept":"application/json"
    
    ]

    func getData<T:Decodable>(url:UrlEndPoints,decodingModel:T.Type , completion : @escaping (Result<T,Error>) -> Void){
      
          AF.request(url.Url,headers: self.headerApi).validate(statusCode: 200 ..< 299).responseDecodable(of:T.self ){ response in
                switch response.result{
                case.success(let data ):
                    completion(.success(data))

                case.failure(let error ):
                   
                    if let  statusCode = response.response?.statusCode{
                        
                        switch statusCode{
                        case 400 :completion(.failure(ApiError.badRequest))
                        case 401 :completion(.failure(ApiError.unAuthoried))
                        case 403 :completion(.failure(ApiError.forbidden))
                        case 404 :completion(.failure(ApiError.notFound))
                        case 407 :completion(.failure(ApiError.authonticationRequired))
                        case 408 :completion(.failure(ApiError.requestTimeOut))
                        case 500 :completion(.failure(ApiError.serverError))
                        default  :completion(.failure(ApiError.serverError))
                          
                        }
                    }
                    else{
                        completion(.failure(ApiError.offline))
                    }
                    
                }
            
        }
       
    }
    
    
    
    
}
