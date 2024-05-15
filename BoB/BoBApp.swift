//
//  BoBApp.swift
//  BoB
//
//  Created by Adrien Freire on 16/04/2024.
//

import SwiftUI

@main
struct BoBApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView(vm: BobAppViewModel(context: dataController.container.viewContext))
        }
    }
}
