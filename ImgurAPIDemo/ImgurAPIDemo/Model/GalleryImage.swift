//
//  GalleryImage.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 17/03/21.
//

import UIKit

final class GalleryImage: NSObject, Codable {
    
    private enum  CodingKeys: String, CodingKey { case id, title, imageDescription = "description", type, link, gifLink = "gifv" }

    var id: String?
    var title: String?
    var imageData: Data?
    var imageDescription: String?
    var type: String?
    var link: String?
    var gifLink: String?

    func isMp4Format() -> Bool {
       return self.type == "video/mp4"
    }
}
