//
//  TopWeeklyGalleriesViewController.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 16/03/21.
//

import UIKit

protocol GalleryCellProtocol {
    func reloadCellData(link: String, completion: @escaping(_ newData: Data?) -> Void)
}

class TopWeeklyGalleriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GalleryCellProtocol  {

    // MARK: Variables
    private var galleriesList: Array<Gallery?>? = [] {
        didSet {
            if(galleriesList != nil && galleriesList?.count != 0) {
                self.hideErrorScreen()
                self.topWeeklyGalleriesCollectionView.reloadData()
            }
            else {
                self.showErrorScreen()
            }
        }
    }
    private var refreshControl: UIRefreshControl?
    private var lastQueuedPage: Int = 0
    private var activityView: SpinnerView?
    private var activityIndicator =  UIActivityIndicatorView()
    private var isFetchingNewData = false
    
    // MARK: Outlets
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var topWeeklyGalleriesCollectionView: UICollectionView!
    @IBOutlet var errorView: UIView!
    @IBOutlet var errorMsgLbl: UILabel!
    @IBOutlet var errorMsgReloadBtn: UIButton!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Configure UI elements
        self.setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showActivityIndicator()
        //Get gallery data
        GalleryAPI().getTopGalleriesFromLast(fromDateInterval: .day, completion: { (resultGalleries) in
            self.galleriesList = resultGalleries
            self.hideActivityIndicator()
        })
    }
    
    func setup() {
        //No error is shown before finishing fetching data
        self.hideErrorScreen()
        
        //Configure custom activityView on collectionView RefreshControll
        self.refreshControl = UIRefreshControl()
        let activityView = SpinnerView(frame: CGRect(x: (UIScreen.main.bounds.width/2) - 32, y: self.refreshControl!.center.y - 16, width: 32, height: 32), image: UIImage(named: "reload_icon")!)
        self.refreshControl!.addSubview(activityView)
        self.refreshControl!.backgroundColor = .clear
        self.refreshControl!.tintColor = .clear
        //self.refreshControl.setCustomView(customView: activityView)
        
        //add pullToRefresh
        refreshControl!.addTarget(self, action: #selector(refreshGallery), for: .valueChanged)
        self.topWeeklyGalleriesCollectionView.refreshControl = refreshControl!
        //Register custom cell
        let galleryCellNib = UINib(nibName: "GalleryCollectionViewCell", bundle:nil)
        self.topWeeklyGalleriesCollectionView.register(galleryCellNib, forCellWithReuseIdentifier: "galleryCell")
        let fetchingDataCell = UINib(nibName: "LoadingGalleriesCollectionViewCell", bundle:nil)
        self.topWeeklyGalleriesCollectionView.register(fetchingDataCell, forCellWithReuseIdentifier: "loadingGalleriesCell")
        

        
        //Set screen details
        self.titleLbl.text = "Top Weekly"
        
        //Set activity from collectionview data
        self.activityView = SpinnerView(frame: CGRect(x: (UIScreen.main.bounds.width/2  - 20), y: (UIScreen.main.bounds.height/2 - 20), width: 40, height: 40), image: UIImage(named: "reload_icon")!)
    }

    func showErrorScreen() {
        self.topWeeklyGalleriesCollectionView.isHidden = true
        self.errorMsgLbl.text = MessageConstants.CONNECTION_ERROR
        self.errorView.isHidden = false
        self.errorMsgReloadBtn.isHidden = false
    }
    
    func hideErrorScreen() {
        self.topWeeklyGalleriesCollectionView.isHidden = false
        self.errorView.isHidden = true
        self.errorMsgReloadBtn.isHidden = true
    }
    
    //MARK: Button action
    @IBAction func reloadTableData(_ sender: Any) {
        showActivityIndicator()
        self.refreshGallery(fromErrorMessage: true)
    }
    
    
    //MARK: CellDelegate
    func reloadCellData(link: String, completion: @escaping (Data?) -> Void) {
        print("reload")
        GalleryAPI().getImageDataFrom(link: link) { (newImageData) in
            completion(newImageData)
        }
    }
    
    
    //MARK: Activity
    
    func showActivityIndicator() {
        if let activityIndicator = self.activityView {
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
        self.view.isUserInteractionEnabled = false
    }
    
    func hideActivityIndicator() {
        if let activityIndicator = self.activityView {
            activityIndicator.stopAnimating()
        }
        self.view.isUserInteractionEnabled = true
    }
    
    // MARK: Refresh and Fetch collectionView data from API
    func fecthNewGalleriesDataFromNextPage() {
        self.isFetchingNewData = true
        self.lastQueuedPage += 1
        self.topWeeklyGalleriesCollectionView.reloadSections(IndexSet(integer: 1))
        print("Fetching new data")
        GalleryAPI().getTopGalleriesFromLast(fromDateInterval: .day, continueFromPage: self.lastQueuedPage, completion: { (resultGalleries) in
            //Append new fetched data
            self.galleriesList?.append(contentsOf: resultGalleries)

            //Stop activityIndicator animation
            let spinnerView = self.refreshControl!.subviews.filter() { $0 is SpinnerView }
            if let refreshControlSpinner = spinnerView.first as? SpinnerView {
                refreshControlSpinner.stopAnimating()
            }

            //Remove fetching tag
            self.isFetchingNewData = false
            
            print("New data fetched")
        })
    }
    
    @objc func refreshGallery(fromErrorMessage: Bool = false) {
        if (fromErrorMessage) {
            self.showActivityIndicator()
            self.errorMsgReloadBtn.isHidden = true
        }
        lastQueuedPage = 0
        GalleryAPI().getTopGalleriesFromLast(fromDateInterval: .day, continueFromPage: lastQueuedPage, completion: { (resultGalleries) in
            self.galleriesList = resultGalleries
            self.refreshControl!.endRefreshing()
            if (fromErrorMessage) {
                self.hideActivityIndicator()
            }
        })
        
        //Find customView to start animation. Could also search for view with tag since SpinnerView has a constant tag value already set
        let spinnerView = refreshControl!.subviews.filter() { $0 is SpinnerView }
        if let refreshControlSpinner = spinnerView.first as? SpinnerView {
            refreshControlSpinner.startAnimating()
        }
    }
    
    // MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return galleriesList!.count
        } else if (section == 1 && self.isFetchingNewData) {
            return 1
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section == 0) {
            guard let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as? GalleryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setupCellData(gallery: galleriesList![indexPath.row])
            cell.galleryCellDelegate = self
            return cell
        }
        else if (indexPath.section == 1) {
            guard let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingGalleriesCell", for: indexPath) as? LoadingGalleriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.loadingDataActivityIndicator.startAnimating()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //ContentCell
        if (indexPath.section == 0) {
            //Check user device type
            let isUserOnPhone = (UIDevice.current.userInterfaceIdiom == .phone)
            
            //Set layout according to device type
            let cellsAcross: CGFloat = isUserOnPhone ? 1 : 2
            let spaceBetweenCells: CGFloat = 20
            let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
            return CGSize(width: dim, height: dim)
        } //LoadingData cell
        else if (indexPath.section == 1) {
            let collectionViewWidth = self.topWeeklyGalleriesCollectionView.frame.width
            return CGSize(width: collectionViewWidth, height: 200)
        }

        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    //MARK: ScrollView and IniniteScroll

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let collectionHeight = self.topWeeklyGalleriesCollectionView.frame.height
        if (!isFetchingNewData && (offsetY >= (contentHeight - collectionHeight))) {
            self.topWeeklyGalleriesCollectionView.reloadSections(IndexSet(integer: 1))
            fecthNewGalleriesDataFromNextPage()
        }
    }
}
