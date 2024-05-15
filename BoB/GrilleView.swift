//
//  GrilleView.swift
//  BoB
//
//  Created by FREIRE ELEUTERIO Adrien on 15/05/2024.
//

import SwiftUI

struct GrilleView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 0.5)
                Spacer()
                Rectangle()
                    .frame(height: 0.5)
                Spacer()
            }
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 0.5)
                Spacer()
                Rectangle()
                    .frame(width: 0.5)
                Spacer()
            }
        }
    }
}


//#Preview {
//    GrilleView()
//}
