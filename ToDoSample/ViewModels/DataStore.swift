//
//  DataStore.swift
//  ToDoSample
//
//  Created by Radik Nuriev on 12.01.2023.
//

import Foundation
import Combine


/// This version is refactored by using PassthroughSubject and Set<AnyCancellable>()
// PassthroughSubject -  subject that broadcasts elements to downstream subscribers
// add, update, delete funcions are replaced by publishers accordingly. They can be found in prev commit
class DataStore: ObservableObject {
    @Published var toDos: [ToDo] = []
    @Published var appErr: ErrorType? = nil
    
    var addToDo = PassthroughSubject<ToDo, Never>()
    var updateToDo = PassthroughSubject<ToDo, Never>()
    var deleteToDo = PassthroughSubject<IndexSet, Never>()
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        print(FileManager.docDirURL.path)
        addSubscriptions()
        if FileManager().docExist(named: fileName) {
            loadToDos()
        }
    }
    
    func addSubscriptions() {
        addToDo
            .sink(receiveValue: { [unowned self] toDo in
            toDos.append(toDo)
            saveToDos()
        })
            .store(in: &subscriptions)
        
        updateToDo
            .sink { [unowned self] toDo in
                guard let index = toDos.firstIndex(where: { $0.id == toDo.id}) else { return }
                toDos[index] = toDo
                saveToDos()
            }
            .store(in: &subscriptions)
        
        deleteToDo
            .sink { [unowned self] indexSet in
                toDos.remove(atOffsets: indexSet)
                saveToDos()
            }
            .store(in: &subscriptions)
        
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
