//
//  ReloadingCellCollectionViewCell.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 18/03/21.
//

import UIKit

class LoadingGalleriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet var loadingDataActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
    
    func toggleAnimation() {
        if (self.loadingDataActivityIndicator.isAnimating) {
            self.loadingDataActivityIndicator.stopAnimating()
        } else {
            self.loadingDataActivityIndicator.startAnimating()
        }
    }

}
