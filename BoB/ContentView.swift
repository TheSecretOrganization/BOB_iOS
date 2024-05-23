//
//  ContentView.swift
//  BoB
//
//  Created by Adrien Freire on 16/04/2024.
//

import SwiftUI
import UIKit
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @StateObject var vm: BobAppViewModel

    var body: some View {
        VStack {
            ImageView(vm: vm)
        }
        .alert("An error as occured", isPresented: $vm.cantDl, actions: {})
        .fullScreenCover(isPresented: .constant(vm.state == 1), onDismiss: {
            if (vm.album[vm.index].rear != nil || vm.album[vm.index].front != nil) {
                vm.state = 2
            } else {
                vm.state = 0
            }
        }, content: {
            CameraView(vm: vm, isFront: true)
        }
        )
        .fullScreenCover(isPresented: .constant(vm.state == 2), onDismiss: {
            vm.state = 0
            if (vm.album.last?.front != nil && vm.album.last?.rear != nil) {
                vm.index = vm.album.count - 1
                vm.pos = .topLeft
            } else {
                vm.album.removeLast()
            }
        }, content: {
            if (vm.album.last?.front == nil) {
                CameraView(vm: vm, isFront: false)
            } else {
                CameraView(vm: vm, isFront: true)
            }
        }
        )
    }
}

struct ImageView: View {
    @ObservedObject var vm: BobAppViewModel

    var body: some View {
        GeometryReader { geo in
            VStack {
                if let rear = vm.getRearPicture(), let frt = vm.getFrontPicture(){
                    Image(uiImage: rear)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture { loc in
                            let zoneWidth = geo.size.width / 3
                            let zoneHeight = geo.size.height * 0.68 / 3

                            let isLeft = loc.x < zoneWidth
                            let isMiddleX = loc.x >= zoneWidth && loc.x < 2 * zoneWidth
                            let isRight = loc.x >= 2 * zoneWidth

                            let isTop = loc.y < zoneHeight
                            let isMiddleY = loc.y >= zoneHeight && loc.y < 2 * zoneHeight
                            let isBottom = loc.y >= 2 * zoneHeight

                            switch (isLeft, isMiddleX, isRight, isTop, isMiddleY, isBottom) {
                            case (true, false, false, true, false, false):
                                    vm.changeLoc(x: 0, y: 0, ali: .topLeft) // Top-left
                            case (false, true, false, true, false, false):
                                    vm.changeLoc(x: 1, y: 0, ali: .topCenter) // Top-center
                            case (false, false, true, true, false, false):
                                    vm.changeLoc(x: 2, y: 0, ali: .topRight) // Top-right
                            case (true, false, false, false, true, false):
                                    vm.changeLoc(x: 0, y: 1, ali: .middleLeft) // Middle-left
                            case (false, true, false, false, true, false):
                                    vm.changeLoc(x: 1, y: 1, ali: .middleCenter) // Middle-center
                            case (false, false, true, false, true, false):
                                    vm.changeLoc(x: 2, y: 1, ali: .middleRight) // Middle-right
                            case (true, false, false, false, false, true):
                                    vm.changeLoc(x: 0, y: 2, ali: .bottomLeft) // Bottom-left
                            case (false, true, false, false, false, true):
                                    vm.changeLoc(x: 1, y: 2, ali: .bottomCenter) // Bottom-center
                            case (false, false, true, false, false, true):
                                    vm.changeLoc(x: 2, y: 2, ali: .bottomRight) // Bottom-right
                            default:
                                break
                            }
                        }
                        .overlay {
                            GrilleView()
                        }
                        .overlay {
                            Image(uiImage: frt.withRoundedCorners(radius: 142))
                                .resizable()
                                .scaledToFit()
                                .frame(width: (geo.size.width / frt.size.width) * (frt.size.width / 2.6),
                                       height: (geo.size.height  * 0.68 / frt.size.height) * (frt.size.height / 2.6))
                                .aligned(vm.pos)
                                .padding(6)
                                .onTapGesture {
                                    vm.changeCamera()
                                }
                        }
                } else {
                    Color.gray
                        .frame(width: geo.size.width)
                        .scaledToFill()
                }
                CustomModalView(vm: vm)
                    .frame(width: geo.size.width, height: geo.size.height * 0.3, alignment: .bottom)
            }
        }
    }

}
