//
//  CustomModalView.swift
//  BoB
//
//  Created by FREIRE ELEUTERIO Adrien on 15/05/2024.
//

import SwiftUI

struct CustomModalView: View {
    @ObservedObject var vm: BobAppViewModel

    var body: some View {
        GestureOptionImageView(vm: vm)
        .background(Color.clear)
        .ignoresSafeArea()
    }
}
struct GestureOptionImageView: View {
    @ObservedObject var vm: BobAppViewModel
    @State var selec: Int = 1
    var body: some View {
        VStack {
            if !vm.isLoading {
                TabView(selection: $selec,
                        content:  {
                    SeePictureView(vm: vm).tabItem {}.tag(1)
                    DlPictureView(vm: vm).tabItem {}.tag(2)
                    UploadView(vm: vm).tabItem {}.tag(3)
                })
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            } else {
                ProgressView()
            }
        }
    }
}

struct UploadView: View {
    @ObservedObject var vm: BobAppViewModel
    @State var image1: UIImage?
    @State var image2: UIImage?
    @State var isPresented1: Bool = false
    @State var isPresented2: Bool = false

    var body: some View {
        HStack {
            Spacer()
            Button {
                isPresented1.toggle()
            } label: {
                if let uiImage = image1 {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 84)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 84)
                }
            }
            Spacer()
            Button {
                if let image1, let image2 {
                    vm.createImage(image1: image1, image2: image2)
                }
            } label: {
                Image(systemName: "arrow.triangle.merge")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 42)
            }
            Spacer()
            Button {
                isPresented2.toggle()
            } label: {
                if let uiImage = image2 {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 84)
                } else {
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 84)
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isPresented1) {
            ImagePickerView(selectedImage: $image1)
        }
        .sheet(isPresented: $isPresented2) {
            ImagePickerView(selectedImage: $image2)
        }
    }
}

struct SeePictureView: View {
    @ObservedObject var vm: BobAppViewModel

    var body: some View {
        HStack(spacing: 42) {
            Button {
                vm.decreaseIndex()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 42, height: 42)
            }

            Button {
                vm.takePicture()
            } label: {
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 126, height: 126)
            }


            Button {
                vm.increaseIndex()
            } label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 42, height: 42)
            }
        }
    }
}
struct DlPictureView: View {
    @ObservedObject var vm: BobAppViewModel

    var body: some View {
        HStack(spacing: 42) {
            Button {
                vm.dlFrontPicture()
            } label: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 42)
            }
            Button {
                vm.dlMergedPicture()
            } label: {
                Image(systemName: "pip")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 42)
            }
            Button {
                vm.dlRearPicture()
            } label: {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 42)
            }
            Button {
                vm.deleteImage()
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 42)
            }
        }
    }
}


