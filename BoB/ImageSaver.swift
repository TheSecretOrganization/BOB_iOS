//
//  ImageSaver.swift
//  BoB
//
//  Created by FREIRE ELEUTERIO Adrien on 17/05/2024.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    var onComplete: ((Result<Void, Error>) -> Void)?

    func writeToPhotoAlbum(image: UIImage, onComplete: @escaping (Result<Void, Error>) -> Void) {
        self.onComplete = onComplete
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            onComplete?(.failure(error))
        } else {
            onComplete?(.success(()))
        }
    }
}
