//
//  Gallery.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 17/03/21.
//

import UIKit

final class Gallery: NSObject, Codable {
    
    //MARK: Variables
    var id: String?
    var cover: String?
    var ups: Int?
    var views: Int?
    var commentCount: Int?
    var coverImage: Data?
    var images: Array<GalleryImage>?
    
}
