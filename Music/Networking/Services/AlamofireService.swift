//
//  AlamofireService.swift
//  Music
//
//  Created by Erislam Nurluyol on 10.11.2023.
//

import Alamofire

protocol AlamofireServiceProtocol: AnyObject {
    func fetch<T: Codable>(path: String, onSuccess: @escaping (T) -> Void, onError: @escaping (AFError) -> Void)
}

final class AlamofireService {
    
    static let shared = AlamofireService()
    
    private init() {}
    
}

extension AlamofireService: AlamofireServiceProtocol {
    func fetch<T: Codable>(path: String, onSuccess: @escaping (T) -> Void, onError: @escaping (AFError) -> Void) {
        AF.request(path).validate().responseDecodable(of: T.self) { response in
            if let error = response.error { onError(error) }
            guard let model = response.value else { return }
            onSuccess(model)
        }
    }
}
