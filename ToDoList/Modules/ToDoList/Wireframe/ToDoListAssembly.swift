//
//  ToDoListAssembly.swift
//  ToDoList
//
//  Created Александр Минк on 29.11.2024.
//

final class ToDoListAssembly: Assembly {
    
    static func assembleModule() -> Module {
        
        let managers = ManagerFactory.shared
        let services = ServiceFactory.shared
        
        let networkService = ToDoListNetworkService(alamofireService: services.alamofireService)
        let tableViewManager = ToDoListTableViewManager()
        let dataConverter = ToDoListDataConverter(coreDataManager: managers.coreDataManager)
        
        let view = ToDoListViewController()
        let router = ToDoListRouter(transition: view)
        let presenter = ToDoListPresenter(dataConverter: dataConverter, userDefaults: services.standardUserDefaults)
        let interactor = ToDoListInteractor(networkService: networkService,
                                            coreDataManager: managers.coreDataManager)
        
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
