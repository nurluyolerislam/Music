//
//  AlamofireService.swift
//  Music
//
//  Created by Erislam Nurluyol on 10.11.2023.
//

import Alamofire

protocol ServiceProtocol: AnyObject {
    func fetch<T>(path: String, onSuccess: @escaping (T) -> Void, onError: @escaping (AFError) -> Void) where T: Codable
}

final class AlamofireService: ServiceProtocol {
    
    func fetch<T>(path: String, onSuccess: @escaping (T) -> Void, onError: @escaping (AFError) -> Void) where T: Codable {
        AF.request(path).validate().responseDecodable(of: T.self) { (response) in
            guard let model = response.value else {
                print(response)
                return
            }
            onSuccess(model)
        }
    }
    
}
