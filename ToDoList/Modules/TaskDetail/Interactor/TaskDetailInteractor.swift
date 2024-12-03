//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created Александр Минк on 02.12.2024.
//

protocol TaskDetailInteractorInput { 
    func saveTask(task: TaskModel)
}

final class TaskDetailInteractor {
    
    // MARK: - Properties
    
    weak var presenter: TaskDetailInteractorOutput?
    
    private let coreDataManager: CoreDataManagerInput
        
    
    // MARK: - Init
    
    init(coreDataManager: CoreDataManagerInput) {
        self.coreDataManager = coreDataManager
    }
    
}


// MARK: - TaskDetailInteractorInput
extension TaskDetailInteractor: TaskDetailInteractorInput {
    
    func saveTask(task: TaskModel) {
        coreDataManager.saveTasks(tasks: [task])
    }
    
}
