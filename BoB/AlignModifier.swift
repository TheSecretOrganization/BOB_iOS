//
//  AlignModifier.swift
//  BoB
//
//  Created by FREIRE ELEUTERIO Adrien on 15/05/2024.
//

import SwiftUI

struct AlignModifier: ViewModifier {
    enum Alignment {
        case topLeft, topCenter, topRight
        case middleLeft, middleCenter, middleRight
        case bottomLeft, bottomCenter, bottomRight
    }

    var alignment: Alignment

    func body(content: Content) -> some View {
        VStack {
            if alignment == .middleLeft || alignment == .middleCenter || alignment == .middleRight || alignment == .bottomLeft || alignment == .bottomCenter || alignment == .bottomRight {
                Spacer()
            }
            HStack {
                if alignment == .topCenter || alignment == .middleCenter || alignment == .bottomCenter || alignment == .topRight || alignment == .middleRight || alignment == .bottomRight {
                    Spacer()
                }
                content
                if alignment == .topCenter || alignment == .middleCenter || alignment == .bottomCenter || alignment == .topLeft || alignment == .middleLeft || alignment == .bottomLeft {
                    Spacer()
                }
            }
            if alignment == .topLeft || alignment == .topCenter || alignment == .topRight || alignment == .middleLeft || alignment == .middleCenter || alignment == .middleRight {
                Spacer()
            }
        }
    }
}

extension View {
    func aligned(_ alignment: AlignModifier.Alignment) -> some View {
        self.modifier(AlignModifier(alignment: alignment))
    }
}

//#Preview {
//    AlignModifier()
//}
