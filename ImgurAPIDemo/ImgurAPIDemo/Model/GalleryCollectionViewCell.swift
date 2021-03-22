//
//  GalleryCollectionViewCell.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 17/03/21.
//

import UIKit

//Obs.: Gif images not working at moment because of the format they are downloaded. Would need to convert it to gif, but I did not have time to finish this behavior

class GalleryCollectionViewCell: UICollectionViewCell {

    //MARK: Cell fields
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var upVotesLbl: UILabel!
    @IBOutlet var commentsLbl: UILabel!
    @IBOutlet var viewsLbl: UILabel!
    @IBOutlet var galleryInfoView: UIView!
    @IBOutlet var reloadGalleryBtn: UIButton!
    @IBOutlet var reloadGalleryBtnHeightConstr: NSLayoutConstraint!
    
    //MARK: Variables
    var galleryCellDelegate: GalleryCellProtocol?
    var currentGallery: Gallery?
    
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
        self.currentGallery = receivedGallery
        self.configureGalleryImage(receivedGallery: gallery)
        self.upVotesLbl.text = formatNumbersToEngineeringNotation(from: gallery.ups ?? 0)
        self.viewsLbl.text = formatNumbersToEngineeringNotation(from: gallery.views ?? 0)
        self.commentsLbl.text = formatNumbersToEngineeringNotation(from: gallery.commentCount ?? 0)
    }
    
    func configureGalleryImage(receivedGallery: Gallery) {
        var imagedLoadStatus = false
        if let receivedCoverImage = receivedGallery.coverImage, let coverImageData = receivedCoverImage.imageData {
            if (receivedCoverImage.isMp4Format()) {
                if let gifImage = UIImageView.fromGif(frame: self.coverImage.frame, data: coverImageData) {
                    self.coverImage = gifImage
                    imagedLoadStatus = true
                }
            } else {
                if let loadedCoverImage = UIImage(data: coverImageData) {
                    imagedLoadStatus = true
                    self.coverImage.image = loadedCoverImage
                }
            }
        }
        loadedCoverImageWith(success: imagedLoadStatus)
        //        if let coverImageData = gallery.coverImage, let loadedCoverImage = UIImage(data: coverImageData) {
        //            loadedCoverImageWith(success: true)
        //            self.coverImage.image = loadedCoverImage
        //        } else {
        //            loadedCoverImageWith(success: false)
        //        }
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
    
    
    func formatNumbersToEngineeringNotation(from value: Int) -> String {
        return value.engineeringNotation
    }
    
    
    //MARK: Cell actions
    
    @IBAction func reloadGallery(_ sender: UIButton) {
        print("reaload cover image")
        //Just update the image data and try to reload it. Only possible if cell stores a current gallery to reload it
        if let reloadDataDelegate = galleryCellDelegate, let gallery = self.currentGallery, let coverImageData = gallery.coverImage {
            reloadDataDelegate.reloadCellData(link: coverImageData.link ?? "") { (newImageData) in
                    gallery.coverImage?.imageData = newImageData
                    self.configureGalleryImage(receivedGallery: gallery)
            }
        }
    }
}

extension UIImageView {
    static func fromGif(frame: CGRect, data: Data?) -> UIImageView? {
        guard let gifData = data,
              let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}

extension Int {
    var engineeringNotation: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
        }
    }
}
