//
//  CameraView.swift
//  BoB
//
//  Created by FREIRE ELEUTERIO Adrien on 29/04/2024.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: BobAppViewModel
    var isFront: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        // Initialiser toujours avec la caméra arrière par défaut
        picker.cameraDevice = isFront ? .rear : .front
        picker.cameraFlashMode = .off
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                if (picker.cameraDevice == .rear) {
                    parent.vm.album.last?.rear = image.heicData()
                    parent.vm.album.last?.widthRear = Int64(image.size.width)
                    parent.vm.album.last?.heightRear = Int64(image.size.height)
                } else {
                    parent.vm.album.last?.front = image.heicData()
                    parent.vm.album.last?.widthFront = Int64(image.size.width)
                    parent.vm.album.last?.heightFront = Int64(image.size.height)
                }
                picker.dismiss(animated: true) {
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

