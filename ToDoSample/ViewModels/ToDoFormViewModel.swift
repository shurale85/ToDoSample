//
//  ToDoFormViewModel.swift
//  ToDoSample
//
//  Created by Radik Nuriev on 12.01.2023.
//

import Foundation

class ToDoFormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var completed: Bool = false
    var id: String?
    
    var updating: Bool {
        id != nil
    }
    
    var isDisabled: Bool {
        name.isEmpty
    }
    
    init() {}
    
    init(_ currentToDo: ToDo) {
        name = currentToDo.name
        completed = currentToDo.completed
        id = currentToDo.id
    }
}
