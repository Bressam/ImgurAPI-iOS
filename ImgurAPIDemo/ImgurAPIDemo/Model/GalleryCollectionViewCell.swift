//
//  GalleryCollectionViewCell.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 17/03/21.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    //MARK: Cell fields
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var upVotesLbl: UILabel!
    @IBOutlet var commentsLbl: UILabel!
    @IBOutlet var viewsLbl: UILabel!
    @IBOutlet var galleryInfoView: UIView!
    @IBOutlet var reloadGalleryBtn: UIButton!
  
    //MARK: Cell setup
    override func awakeFromNib() {
        super.awakeFromNib()
        //Configure appearance
        self.galleryInfoView.layer.cornerRadius = 5;
        self.galleryInfoView.clipsToBounds = true;
    }
    
    /**
     Configure all object data to its fields on cell
     */
    func setupCellData() {
    }

    /**
     Set the collectionCell to state of correctly loaded cover image or not. If loaded successfully, cell will show the image.
        Otherwhse, it will show and reload button
     */
    func loadedCoverImageWith(success loaded: Bool) {
        if loaded {
            self.reloadGalleryBtn.isHidden = true
            self.coverImage.isHidden = false
        } else {
            self.reloadGalleryBtn.isHidden = false
            self.coverImage.isHidden = true
        }
    }
    
    
    //MARK: Cell actions
    
    @IBAction func reloadGallery(_ sender: UIButton) {
        print("realod cover image")
    }
}
