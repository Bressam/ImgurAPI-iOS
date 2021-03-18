//
//  responseData.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 18/03/21.
//

import UIKit

final class GalleriesResponseData: NSObject, Codable {
    
    private enum  CodingKeys: String, CodingKey { case galleryList = "data" }
    
    let galleryList: Array<Gallery?>
}
