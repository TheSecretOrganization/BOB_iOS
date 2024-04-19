//
//  ContentView.swift
//  BoB
//
//  Created by Adrien Freire on 16/04/2024.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var actual: Picture?
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
                    parent.actual!.back = image
                } else {
                    parent.actual!.front = image
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

struct Picture {
    var front: UIImage?
    var back: UIImage?
    var posX: CGFloat = 50
    var posY: CGFloat = 50
}

struct ContentView: View {
    @State private var AllImage: [Picture] = []
    @State private var isCameraPresented = false
    @State private var isDone = false
    @State private var index :Int = 0
    @State private var actual : Picture?
    @State private var state: Int = 0

    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geo in
                    if !AllImage.isEmpty, let bck = AllImage[index].back, let frt = AllImage[index].front {
                        Image(uiImage: bck.overlayWith(image: frt.withBorderAndRoundedCorners(borderWidth: 100, borderColor: .black, cornerRadius: 142), posX: AllImage[index].posX, posY: AllImage[index].posY, width: frt.size.width/2, height: frt.size.height/2))
                            .resizable()
                            .scaledToFit()
                            .onTapGesture { loc in
                                let isRight = loc.x < geo.size.width / 2
                                let isUpper = loc.y < geo.size.height / 2
                                switch (isRight, isUpper) {
                                case (true, true):
                                    AllImage[index].posX = 50
                                    AllImage[index].posY = 50
                                case (false, true):
                                    AllImage[index].posX = bck.size.width - frt.size.width / 2 - 50
                                    AllImage[index].posY = 50
                                case (true, false):
                                    AllImage[index].posX = 50
                                    AllImage[index].posY = bck.size.height - frt.size.height / 2 - 50
                                case (false, false):
                                    AllImage[index].posX = bck.size.width - 50 - frt.size.width / 2
                                    AllImage[index].posY = bck.size.height - 50 - frt.size.height / 2
                                }
                            }
                    } else {
                        Color.gray
                            .frame(width: geo.size.width)
                            .scaledToFill()
                    }
                }
            }
            VStack {
                HStack(spacing: 42) {
                    Button {
                        if (index - 1 >= 0) {
                            index -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 42, height: 42)
                    }
                    
                    Button {
                        state = 1
                        actual = Picture()
                    } label: {
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 126, height: 126)
                    }
                    
                    
                    Button {
                        if (index + 1 < AllImage.count) {
                            index += 1
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 42, height: 42)
                    }
                }
                HStack(spacing: 42) {
                    Button {
                        if !AllImage.isEmpty, let bck = AllImage[index].back, let frt = AllImage[index].front {
                            UIImageWriteToSavedPhotosAlbum(frt, self, nil, nil)
                            isDone.toggle()
                        }
                    } label: {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 42)
                    }
                    Button {
                        if !AllImage.isEmpty, let bck = AllImage[index].back, let frt = AllImage[index].front {
                            UIImageWriteToSavedPhotosAlbum(bck.overlayWith(image: frt.withBorderAndRoundedCorners(borderWidth: 100, borderColor: .black, cornerRadius: 142), posX: AllImage[index].posX, posY: AllImage[index].posY, width: frt.size.width/2, height: frt.size.height/2), self, nil, nil)
                            isDone.toggle()
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 42)
                    }
                    Button {
                        if !AllImage.isEmpty, let bck = AllImage[index].back, let frt = AllImage[index].front {
                            UIImageWriteToSavedPhotosAlbum(bck, self, nil, nil)
                            isDone.toggle()
                        }
                    } label: {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 42)
                    }
                }
            }
            .padding(.top)
        }
        .alert("Done", isPresented: $isDone, actions: {
            Text("Done")
        })
        .fullScreenCover(isPresented: .constant(state == 1), onDismiss: {
            if (actual?.back != nil || actual?.front != nil) {
                state = 2
            } else {
                actual = nil
                state = 0
            }
        }, content: {
            CameraView(actual: $actual, isFront: true)
        })
        .fullScreenCover(isPresented: .constant(state == 2), onDismiss: {
            state = 0
            if (actual?.front != nil && actual?.back != nil) {
                AllImage.append(actual!)
                index = AllImage.count - 1
            }
            actual = nil
        }, content: {
            if (actual?.front == nil) {
                CameraView(actual: $actual, isFront: false)
            } else {
                CameraView(actual: $actual, isFront: true)
            }
        })
        .onChange(of: actual?.front) {
            
        }
    }
}

extension UIImage {
    func overlayWith(image: UIImage, posX: CGFloat, posY: CGFloat, width: CGFloat? = nil, height: CGFloat? = nil) -> UIImage {
        let newWidth = width ?? image.size.width
        let newHeight = height ?? image.size.height
        let newSize = CGSize(width: max(self.size.width, posX + newWidth), height: max(self.size.height, posY + newHeight))
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        image.draw(in: CGRect(x: posX, y: posY, width: newWidth, height: newHeight), blendMode: .normal, alpha: 1.0)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }

    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat = radius ?? maxRadius

        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()

        context?.beginPath()
        context?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath)
        context?.clip()

        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? self
    }
    func withBorder(width: CGFloat, color: UIColor) -> UIImage {
            let size = CGSize(width: self.size.width + 2 * width, height: self.size.height + 2 * width)
            UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
            let rect = CGRect(x: width, y: width, width: self.size.width, height: self.size.height)

            color.set()
            UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            self.draw(in: rect)
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return result ?? self
        }
    func withBorderAndRoundedCorners(borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat) -> UIImage {
            let size = CGSize(width: self.size.width + 2 * borderWidth, height: self.size.height + 2 * borderWidth)
            UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
            
            let rect = CGRect(x: borderWidth, y: borderWidth, width: self.size.width, height: self.size.height)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            
            borderColor.set()
            path.fill()
            
            path.addClip()
            self.draw(in: rect)
            
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return result ?? self
        }
}

