//
//  TopWeeklyGalleriesViewController.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 16/03/21.
//

import UIKit

class TopWeeklyGalleriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var topWeeklyGalleriesCollectionView: UICollectionView!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register custom cell
        let nib = UINib(nibName: "GalleryCollectionViewCell", bundle:nil)
        self.topWeeklyGalleriesCollectionView.register(nib, forCellWithReuseIdentifier: "galleryCell")
        
        //Set screen details
        self.titleLbl.text = "Top Weekly"
    }


    
    // MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Check user device type
        let isUserOnPhone = (UIDevice.current.userInterfaceIdiom == .phone)
        
        //Set layout according to device type
        let cellsAcross: CGFloat = isUserOnPhone ? 1 : 2
        let spaceBetweenCells: CGFloat = 20
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    

}
