//
//  ToDo.swift
//  ToDoSample
//
//  Created by Radik Nuriev on 12.01.2023.
//

import Foundation

struct ToDo: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var completed: Bool = false
    
    static var fakeData: [ToDo] {
        [
            ToDo(name: "Buy Oil"),
            ToDo(name: "Play with children", completed: true)
        ]
    }
}
