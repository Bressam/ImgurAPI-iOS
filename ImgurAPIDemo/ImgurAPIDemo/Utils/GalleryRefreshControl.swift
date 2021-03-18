//
//  galleryRefreshControl.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 18/03/21.
//

import UIKit

final class GalleryRefreshControl: UIRefreshControl {

    func setCustomView(customView: UIView) {
        customView.center = self.center
        print(customView.center)
        print(self.center)
        self.addSubview(customView)
        self.backgroundColor = .clear
        self.tintColor = .clear
    }
    
}
