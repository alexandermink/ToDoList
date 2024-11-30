//
//  ToDoListAssembly.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

final class ToDoListAssembly: Assembly {
    
    static func assembleModule() -> Module {
        
        let services = ServiceFactory.shared
        
        let networkService = ToDoListNetworkService(alamofireService: services.alamofireService)
        let tableViewManager = ToDoListTableViewManager()
        let dataConverter = ToDoListDataConverter()
        
        let view = ToDoListViewController()
        let router = ToDoListRouter(transition: view)
        let presenter = ToDoListPresenter(dataConverter: dataConverter)
        let interactor = ToDoListInteractor(networkService: networkService)
        
        tableViewManager.delegate = presenter
        
        view.presenter = presenter
        view.tableViewManager = tableViewManager
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        return view
    }

}
