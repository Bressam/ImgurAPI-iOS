//
//  TopWeeklyGalleriesViewController.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 16/03/21.
//

import UIKit

class TopWeeklyGalleriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: Variables
    var galleriesList: Array<Gallery?>? = [] {
        didSet {
            self.topWeeklyGalleriesCollectionView.reloadData()
        }
    }
    
    // MARK: Outlets
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
        
        //Fix:
        // - A lista retorna vazia pois ainda está sendo preenchida, uma vez na primeira requisicao, e outra na requisicao de imagens. É preciso aguardar as duas para repopular a collectionview
        // - Retornar true ou false como antes, e assim é possível deixar uma acitivy rodando na tela enquanto a requisicao é feita
        
        GalleryAPI().getTopGalleriesFromLast(fromDateInterval: .day, completion: { (resultGalleries) in
            self.galleriesList = resultGalleries
        })
//        , completionHandler: { (success) in
//            if (success) {
//              //  self.topWeeklyGalleriesCollectionView.reloadData()
//            } else {
//               // self.showErrorScreen()
//            }
//        })
    }

    func showErrorScreen() {
        
    }
    
    // MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(galleriesList!.count)
        return galleriesList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCellData(gallery: galleriesList![indexPath.row])
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
