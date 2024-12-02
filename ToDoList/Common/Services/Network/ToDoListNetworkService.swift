//
//  ToDoListNetworkService.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol ToDoListNetworkServiceInput { 
    func fetchTasks(completion: @escaping (Result<ToDoListModel, Error>) -> Void)
}

final class ToDoListNetworkService {
    
    // MARK: - Locals
    
    private enum Locals {
        static let endpoint = "/todos"
    }
    
    
    // MARK: - Properties
    
    private let alamofireService: AlamofireServiceInput
    
    
    // MARK: - Init
    
    init(alamofireService: AlamofireServiceInput) {
        self.alamofireService = alamofireService
    }
    
}


// MARK: - ToDoListNetworkServiceInput
extension ToDoListNetworkService: ToDoListNetworkServiceInput { 
    
    func fetchTasks(completion: @escaping (Result<ToDoListModel, Error>) -> Void) {
        
        alamofireService.request(
            endpoint: Locals.endpoint,
            method: .get,
            parameters: nil,
            headers: nil
        ) { (result: Result<ToDoListModel, Error>) in
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}
