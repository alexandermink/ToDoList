//
//  AlamofireService.swift
//  ToDoList
//
//  Created by Александр Минк on 29.11.2024.
//

import Alamofire

protocol AlamofireServiceInput {
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        headers: HTTPHeaders?,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class AlamofireService {
    
    // MARK: - Locals
    
    private enum Locals {
        static let baseURL = "https://dummyjson.com"
    }
    
    
    // MARK: - Properties
    
    static let shared = AlamofireService()
        
    
    // MARK: - Init

    private init() {}
    
}


// MARK: - AlamofireServiceInput
extension AlamofireService: AlamofireServiceInput {
    
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let url = "\(Locals.baseURL)\(endpoint)"

        AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: parameters == nil ? URLEncoding.default : JSONEncoding.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decodedResponse):
                completion(.success(decodedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
