//
//  DataStore.swift
//  ToDoSample
//
//  Created by Radik Nuriev on 12.01.2023.
//

import Foundation

class DataStore: ObservableObject {
    @Published var toDos: [ToDo] = []
    @Published var appErr: ErrorType? = nil
    
    init() {
        print(FileManager.docDirURL.path)
        if FileManager().docExist(named: fileName) {
            loadToDos()
        }
    }
    
    func addToDo(_ toDo: ToDo) {
        toDos.append(toDo)
        saveToDos()
    }
    
    func updateToDo(_ toDo: ToDo) {
        guard let index = toDos.firstIndex(where: { $0.id == toDo.id}) else { return }
        toDos[index] = toDo
        saveToDos()
    }
    
    func deleteToDo(at indexSet: IndexSet) {
        toDos.remove(atOffsets: indexSet)
        saveToDos()
    }
    
    func loadToDos() {
        FileManager().readDocument(docName: fileName) { result in
            switch result {
            case .success(let data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    toDos = try decoder.decode([ToDo].self, from: data)
                } catch {
                    appErr = ErrorType(error: .decodingError)
                }
            case .failure(let err):
                appErr = ErrorType(error: err)
            }
        }
    }
    
    func saveToDos() {
        print("Saving toDos to file system")
        let encoder: JSONEncoder = JSONEncoder()
        do {
            let data = try encoder.encode(toDos)
            let jsonString = String(decoding: data, as: UTF8.self)
            FileManager().saveDocument(contents: jsonString, docName: fileName) { error in
                if let error = error {
                    appErr = ErrorType(error: error)
                }
            }
        } catch {
            appErr = ErrorType(error: .encodingError)
        }
    }
}
