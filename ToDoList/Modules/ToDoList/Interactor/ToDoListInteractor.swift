//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol ToDoListInteractorInput { 
    func fetchTasks(completion: @escaping (ToDoListModel) -> Void)
}

final class ToDoListInteractor {
    
    // MARK: - Properties
    
    weak var presenter: ToDoListInteractorOutput?
    
    private let networkService: ToDoListNetworkServiceInput
    
    
    // MARK: - Init
    
    init(networkService: ToDoListNetworkServiceInput) {
        self.networkService = networkService
    }
    
}


// MARK: - ToDoListInteractorInput
extension ToDoListInteractor: ToDoListInteractorInput { 
    
    func fetchTasks(completion: @escaping (ToDoListModel) -> Void) {
        
        networkService.fetchTasks { response in
            switch response {
            case .success(let data):
                completion(data)
            case .failure(let error):
                // TODO: доработать alert
                print(error.localizedDescription)
            }
        }
        // else coredata fetch
    }
    
}
