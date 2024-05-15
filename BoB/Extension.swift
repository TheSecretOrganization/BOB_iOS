//
//  Extension.swift
//  BoB
//
//  Created by FREIRE ELEUTERIO Adrien on 29/04/2024.
//

import Foundation
import SwiftUI

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
