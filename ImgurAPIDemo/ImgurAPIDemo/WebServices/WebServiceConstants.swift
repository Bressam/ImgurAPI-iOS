//
//  WebServiceConstants.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 17/03/21.
//

import Foundation

struct WebServiceConstants {
    //application id and secret, generated to be able to use API without user logged in
    static let CLIENT_ID: String = "2375a807e62ab97"
    static let CLIENT_SECRET: String = "a8f79ce86d1cfbfb7b40c5ade61a13ff7d59b20c"

    // Requests URLs
    static let GALLERY_URL_WITH_PARAMS = "https://api.imgur.com/3/gallery/{{section}}/{{sort}}/{{window}}/{{page}}?showViral={{showViral}}&mature={{showMature}}&album_previews={{albumPreviews}}"
}
