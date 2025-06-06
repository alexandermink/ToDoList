//
//  ToDoListDataConverterTests.swift
//  ToDoListTests
//
//  Created by Александр Минк on 06.06.2025.
//

import XCTest
@testable import ToDoList

final class ToDoListDataConverterTests: XCTestCase {

    // MARK: - Properties

    private var converter: ToDoListDataConverter!
    private var coreDataManager: CoreDataManagerInput!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
        converter = ToDoListDataConverter(coreDataManager: coreDataManager)
    }

    override func tearDown() {
        converter = nil
        coreDataManager = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testConvertToDoListModelToViewModel() {
        let model = ToDoListModel(todos: [
            ToDoTask(id: 1, todo: "Buy milk", completed: false, userId: 1),
            ToDoTask(id: 2, todo: "Write code", completed: true, userId: 1)
        ])
        
        let viewModel: ToDoListViewModel = converter.convert(model)

        XCTAssertEqual(viewModel.rows.count, 2)
        XCTAssertEqual(viewModel.rows[0].id, 1)
        XCTAssertEqual(viewModel.rows[0].title, "Buy milk")
        XCTAssertEqual(viewModel.rows[0].isCompleted, false)

        XCTAssertEqual(viewModel.rows[1].id, 2)
        XCTAssertEqual(viewModel.rows[1].title, "Write code")
        XCTAssertEqual(viewModel.rows[1].isCompleted, true)
    }

    func testConvertTaskModelArrayToViewModelSorted() {
        let now = Date()
        let oldDate = now.addingTimeInterval(-10000)

        let models = [
            TaskModel(id: 2, title: "Second", desc: nil, createdAt: oldDate, isCompleted: false),
            TaskModel(id: 1, title: "First", desc: "important", createdAt: now, isCompleted: true)
        ]

        let viewModel = converter.convert(models)

        XCTAssertEqual(viewModel.rows.count, 2)
        XCTAssertEqual(viewModel.rows[0].id, 1)
        XCTAssertEqual(viewModel.rows[0].title, "First")
        XCTAssertEqual(viewModel.rows[1].id, 2)
    }

    func testConvertToDoListModelToTaskModels() {
        let model = ToDoListModel(todos: [
            ToDoTask(id: 5, todo: "Do laundry", completed: false, userId: 42)
        ])

        let result: [TaskModel] = converter.convert(model)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, 5)
        XCTAssertEqual(result[0].title, "Do laundry")
        XCTAssertEqual(result[0].isCompleted, false)
    }
}

