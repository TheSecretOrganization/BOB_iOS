//
//  DataController.swift
//  BoB
//
//  Created by FREIRE ELEUTERIO Adrien on 29/04/2024.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "PictureData")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
