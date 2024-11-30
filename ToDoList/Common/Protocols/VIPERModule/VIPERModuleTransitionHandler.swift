//
//  VIPERModuleTransitionHandler.swift
//  ToDoList
//
//  Created by Александр Минк on 29.11.2024.
//

import UIKit

protocol TransitionModel {  }

protocol ModuleTransitionHandler where Self: UIViewController {  }

extension UIViewController: ModuleTransitionHandler {  }

extension ModuleTransitionHandler {
    
    func present<ModuleType: Assembly>(with model: TransitionModel, openModuleType: ModuleType.Type) {
        let view = ModuleType.assembleModule(with: model)
        present(view, animated: true)
    }
    
    func present<ModuleType: Assembly>(animated: Bool, moduleType: ModuleType.Type) {
        let view = ModuleType.assembleModule()
        present(view, animated: animated)
    }
    
    func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        present(viewController, animated: animated, completion: completion)
    }
    
    func show<ModuleType: Assembly>(with model: TransitionModel, openModuleType: ModuleType) {
        let view = ModuleType.assembleModule(with: model)
        show(view, sender: nil)
    }
    
    func show(view: UIViewController) {
        show(view, sender: nil)
    }
    
    func push<ModuleType: Assembly>(with model: TransitionModel, openModuleType: ModuleType.Type) {
        let view = ModuleType.assembleModule(with: model)
        navigationController?.pushViewController(view, animated: true)
    }
    
    func push<ModuleType: Assembly>(with model: TransitionModel, openModuleType: ModuleType.Type, animated: Bool) {
        let view = ModuleType.assembleModule(with: model)
        navigationController?.pushViewController(view, animated: animated)
    }
    
    func push<ModuleType: Assembly>(moduleType: ModuleType.Type) {
        let view = ModuleType.assembleModule()
        navigationController?.pushViewController(view, animated: true)
    }
    
    func push<ModuleType: Assembly>(moduleType: ModuleType.Type, animated: Bool) {
        let view = ModuleType.assembleModule()
        navigationController?.pushViewController(view, animated: animated)
    }
    
    func popToRootViewController(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func popToSpecificViewController(withIdentifier identifier: String, animated: Bool) {
            if let navigationController = navigationController {
                for viewController in navigationController.viewControllers {
                    if viewController.restorationIdentifier == identifier {
                        navigationController.popToViewController(viewController, animated: animated)
                        return
                    }
                }
            }
        }
    
    func closeCurrentModule(animated: Bool = true, completion: (() -> Void)? = nil) {
        
        let isInNavigationStack = parent is UINavigationController
        var hasManyControllersInStack = false
        
        if let navigationController = parent as? UINavigationController {
            hasManyControllersInStack = isInNavigationStack ? navigationController.children.count > 1 : false
        }
        
        if isInNavigationStack && hasManyControllersInStack {
            (parent as? UINavigationController)?.popViewController(animated: animated)
            
        } else if presentingViewController != nil {
            dismiss(animated: animated, completion: completion)

        } else if view.superview != nil {
            willMove(toParent: nil)
            view.removeFromSuperview()
            removeFromParent()
        }
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        dismiss(animated: animated, completion: completion)
    }
    
}
