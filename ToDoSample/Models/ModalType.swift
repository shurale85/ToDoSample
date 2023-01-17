//
//  ModalType.swift
//  ToDoSample
//
//  Created by Radik Nuriev on 12.01.2023.
//

import SwiftUI

enum ModalType: Identifiable, View {
    case new
    case update(ToDo)
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }
    
    var body: some View {
        switch self {
        case .new:
            return ToDoFormView(formVM:ToDoFormViewModel())
        case .update(let toDo):
            return ToDoFormView(formVM: ToDoFormViewModel(toDo))
        }
    }
}
