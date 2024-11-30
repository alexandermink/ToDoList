//
//  VIPERModuleViewOutput.swift
//  ToDoList
//
//  Created by Александр Минк on 29.11.2024.
//

protocol ViewOutput: AnyObject {
    func viewIsReady()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
    func viewWillLayoutSubviews()
    func loadViewIfNeeded()
}

extension ViewOutput {
    func viewWillAppear() {  }
    func viewDidAppear() {  }
    func viewWillDisappear() {  }
    func viewDidDisappear() {  }
    func loadViewIfNeeded() {  }
    func viewWillLayoutSubviews() {  }
}
