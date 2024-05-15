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
            TabView(selection: $selec,
                    content:  {
                SeePictureView(vm: vm).tabItem {}.tag(1)
                DlPictureView(vm: vm).tabItem {}.tag(2)
            })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
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


