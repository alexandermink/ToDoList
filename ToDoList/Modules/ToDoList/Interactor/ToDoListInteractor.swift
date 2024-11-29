//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

protocol ToDoListInteractorInput {  }

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
extension ToDoListInteractor: ToDoListInteractorInput {  }
