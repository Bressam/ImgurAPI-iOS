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
    @IBOutlet var reloadGalleryBtnHeightConstr: NSLayoutConstraint!
    
    //MARK: Cell setup
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCellLayout()
    }
    
    /**
     Configures sizes for different devices
     */
    func setupCellLayout() {
        self.galleryInfoView.layer.cornerRadius = 5
        self.galleryInfoView.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.reloadGalleryBtn.imageView?.contentMode = .scaleToFill
        self.layoutIfNeeded()
    }
    
    /**
     Configure all object data to its fields on cell
     */
    func setupCellData(gallery receivedGallery: Gallery?) {
        guard let gallery = receivedGallery else {
            return
        }
        
        if let coverImageData = gallery.coverImage, let loadedCoverImage = UIImage(data: coverImageData) {
            loadedCoverImageWith(success: true)
            self.coverImage.image = loadedCoverImage
        } else {
            loadedCoverImageWith(success: false)
        }
        
        self.upVotesLbl.text = transformInMultipleK(from: gallery.ups ?? 0)
        self.viewsLbl.text = transformInMultipleK(from: gallery.views ?? 0)
        self.commentsLbl.text = transformInMultipleK(from: gallery.commentCount ?? 0)
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
    
    func transformInMultipleK(from value: Int) -> String {
        let isBiggerThan1K = (value >= 1000)
        let formattedValue = (isBiggerThan1K ? value/1000 : value)
        let formattedString = String(formattedValue)
        return (isBiggerThan1K ? formattedString + "K" : formattedString)
    }
    
    
    //MARK: Cell actions
    
    @IBAction func reloadGallery(_ sender: UIButton) {
        print("reaload cover image")
    }
}
