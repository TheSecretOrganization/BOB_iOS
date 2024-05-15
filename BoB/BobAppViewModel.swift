//
//  BobAppViewModel.swift
//  BoB
//
//  Created by FREIRE ELEUTERIO Adrien on 29/04/2024.
//

import Foundation
import CoreData
import UIKit

class BobAppViewModel: ObservableObject {
    private var moc: NSManagedObjectContext

    @Published var album: [PictureData]
    @Published var state: Int = 0
    @Published var index: Int = 0
    @Published var pos: AlignModifier.Alignment = .topLeft

    init(context: NSManagedObjectContext) {
        self.moc = context
        
        // FetchRequest initialisation
        let request: NSFetchRequest<PictureData> = PictureData.fetchRequest()
        request.sortDescriptors = []
        self.album = (try? context.fetch(request)) ?? []
        self.index = album.count - 1
    }
    func setImage() {
        let image = PictureData(context: moc)
        image.posX = 50
        image.posY = 50
        try? moc.save()
        self.album.append(image)
    }

    func deleteImage() {
        guard !album.isEmpty else { return }
        moc.delete(album[index])
        album.remove(at: index)
        index = max(index - 1, 0)
        do {
            try moc.save()
        } catch {
            let nsError = error as NSError
            fatalError("Erreur non résolue \(nsError), \(nsError.userInfo)")
        }
    }

    func changeLoc(x: Int, y: Int, ali: AlignModifier.Alignment) {
        pos = ali
        let wei: Int = Int(album[index].widthRear - album[index].widthFront / 2 - 50)
        let hei: Int = Int(album[index].heightRear - album[index].heightFront / 2 - 50)
        album[index].posX = Int16(50 + wei * x / 2)
        album[index].posY = Int16(50 + hei * y / 2)
        switch ali {
            case .topLeft:
                album[index].pos = 0
            case .topCenter:
                album[index].pos = 1
            case .topRight:
                album[index].pos = 2
            case .middleLeft:
                album[index].pos = 3
            case .middleCenter:
                album[index].pos = 4
            case .middleRight:
                album[index].pos = 5
            case .bottomLeft:
                album[index].pos = 6
            case .bottomCenter:
                album[index].pos = 7
            case .bottomRight:
                album[index].pos = 8
        }
        do {
            try moc.save()
        } catch {
            let nsError = error as NSError
            fatalError("Erreur non résolue \(nsError), \(nsError.userInfo)")
        }
    }

    func mergeImage() {
        guard let rear = UIImage(data: album[index].rear!) else { return }
        guard let front = UIImage(data: album[index].front!) else { return }
        album[index].bigPicture = rear.overlayWith(
            image: front.withRoundedCorners(radius: 142),
            posX: CGFloat(album[index].posX),
            posY: CGFloat(album[index].posY),
            width: front.size.width/2,
            height: front.size.height/2
        ).jpegData(compressionQuality: 50)
        try? moc.save()
    }
}

// MARK: - GETTER

extension BobAppViewModel {
    func getBigPicture() -> UIImage? {
        guard !album.isEmpty else { return nil }
        mergeImage()
        guard let picture = album[index].bigPicture else { return nil }
        return UIImage(data: picture)
    }
    func getRearPicture() -> UIImage? {
        guard !album.isEmpty else { return nil }
        guard let picture = album[index].rear else { return nil }
        return UIImage(data: picture)
    }
    func getFrontPicture() -> UIImage? {
        guard !album.isEmpty else { return nil }
        guard let picture = album[index].front else { return nil }
        return UIImage(data: picture)
    }
    func getPosX() -> CGFloat {
        return CGFloat(album[index].posX)
    }
    func getPosY() -> CGFloat {
        return CGFloat(album[index].posY)
    }
    func getPos() -> AlignModifier.Alignment {
        switch album[index].pos {
            case 0:
                return .topLeft
            case 1:
                return .topCenter
            case 2:
                return .topRight
            case 3:
                return .middleLeft
            case 4:
                return .middleCenter
            case 5:
                return .middleRight
            case 6:
                return .bottomLeft
            case 7:
                return .bottomCenter
            case 8:
                return .bottomRight
            default:
                return .topLeft
        }
    }
}

// MARK: - INDEX

extension BobAppViewModel {
    func increaseIndex() {
        index = min(index + 1, album.count - 1)
        pos = getPos()
    }
    func decreaseIndex() {
        index = max(index - 1, 0)
        pos = getPos()
    }
    func takePicture() {
        state = 1
        setImage()
    }
}

// MARK: - DOWNLOAD

extension BobAppViewModel {
    func dlFrontPicture() {
        if let frt = getFrontPicture() {
            UIImageWriteToSavedPhotosAlbum(frt, self, nil, nil)
        }
    }
    func dlRearPicture() {
        if let frt = getRearPicture() {
            UIImageWriteToSavedPhotosAlbum(frt, self, nil, nil)
        }
    }
    func dlMergedPicture() {
        if let bp = getBigPicture() {
            UIImageWriteToSavedPhotosAlbum(bp, self, nil, nil)
        }
    }
}
