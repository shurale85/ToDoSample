//
//  ToDoSampleApp.swift
//  ToDoSample
//
//  Created by Radik Nuriev on 12.01.2023.
//

import SwiftUI

@main
struct ToDoSampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DataStore())
        }
    }
}
