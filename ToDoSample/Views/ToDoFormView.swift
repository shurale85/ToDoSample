//
//  ToDoFormView.swift
//  ToDoSample
//
//  Created by Radik Nuriev on 13.01.2023.
//

import SwiftUI

struct ToDoFormView: View {
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var formVM: ToDoFormViewModel
    @Environment(\.presentationMode) var presentaionMode: Binding<PresentationMode> //!
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading) {
                    TextField("ToDo", text: $formVM.name)
                    Toggle("Completed", isOn: $formVM.completed)
                }
            }
            .navigationTitle("ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: updateSaveButton)
        }
    }
}

extension ToDoFormView {
    func updateToDo() {
        let toDo = ToDo(id: formVM.id!, name: formVM.name, completed: formVM.completed)
        dataStore.updateToDo.send(toDo) //dataStore.updateToDo(toDo)
        presentaionMode.wrappedValue.dismiss()
    }
    
    func addToDo() {
        let toDo = ToDo(name: formVM.name)
        dataStore.addToDo.send(toDo) //dataStore.addToDo(toDo)
        presentaionMode.wrappedValue.dismiss()
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            presentaionMode.wrappedValue.dismiss()
        }
    }
    
    var updateSaveButton: some View {
        Button(formVM.updating ? "Update" : "Save", action: formVM.updating ? updateToDo : addToDo)
            .disabled(formVM.isDisabled)
    }
}

struct ToDoFormView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoFormView(formVM: ToDoFormViewModel())
            .environmentObject(DataStore())
    }
}
