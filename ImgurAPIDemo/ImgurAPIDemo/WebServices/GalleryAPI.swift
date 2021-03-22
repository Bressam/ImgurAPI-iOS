//
//  GalleryAPI.swift
//  ImgurAPIDemo
//
//  Created by Giovanne Bressam on 17/03/21.
//

import UIKit
import Alamofire
import AlamofireImage

class GalleryAPI: NSObject {

    enum DateIntervals: String {
        case day, week, month, year, all
    }
    
    //DispatchGroup to sync multiple requests
    private var dispatchGroup: DispatchGroup = DispatchGroup()
    
    //AlamoFireImage download to use cache and support more image types
    let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        //maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )
    
    //MARK: Requests
    func getTopGalleriesFromLast(fromDateInterval dateInterval: DateIntervals, continueFromPage page: Int = 0, completion: @escaping(_ : Array<Gallery?>) -> Void) -> Void {
        
        //Fill all URL parameters and variables
        var urlWithParams : String = "https://api.imgur.com/3/gallery/{{section}}/{{sort}}/{{window}}/{{page}}?showViral={{showViral}}&mature={{showMature}}&album_previews={{albumPreviews}}"
        urlWithParams = urlWithParams.replacingOccurrences(of: "{{section}}", with: "top")
        urlWithParams = urlWithParams.replacingOccurrences(of: "{{sort}}", with: "top")
        urlWithParams = urlWithParams.replacingOccurrences(of: "{{window}}", with: dateInterval.rawValue)
        urlWithParams = (page == 0) ? urlWithParams.replacingOccurrences(of: "{{page}}", with: "") : urlWithParams.replacingOccurrences(of: "{{page}}", with: String(page))
        urlWithParams = urlWithParams.replacingOccurrences(of: "{{showViral}}", with: "true")
        urlWithParams = urlWithParams.replacingOccurrences(of: "{{showMature}}", with: "false")
        urlWithParams = urlWithParams.replacingOccurrences(of: "{{albumPreviews}}", with: "true")

        //Set application ID on header
        let headers: HTTPHeaders = ["Authorization" : "Client-ID \(WebServiceConstants.CLIENT_ID)"]
        
        //Request
        var galleries : Array<Gallery?> = []
        //Register the request on dispatch group
        self.dispatchGroup.enter()
        AF.request(urlWithParams, method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                //print(response.value)
                galleries = self.parseGalleriesData(data: response.data)
                break
            case let .failure(error):
                print(error)
                galleries = []
                break
            }
            self.dispatchGroup.leave()
        }
        
        //After all galleries and images are requested, return value
        self.dispatchGroup.notify(queue: .main) {
            completion(galleries)
        }
    }
    
    //Request imageData from image link
    func getImageDataFrom(link imageLink: String?, completion: @escaping(_ imageData: Data?) -> Void) -> Void {
        //register request on dispatchgroup
        self.dispatchGroup.enter()
        if let link = imageLink, let urlLink = URL(string: link) {
            AF.request(urlLink).responseImage { (response) in
                self.dispatchGroup.leave()
                if case .success(let image) = response.result {
                    //print(response.value)
                    //print("image downloaded: \(image)")
                    //completion(image.pngData())
                    completion(response.data)
                } else {
                    completion(nil)
                }
            }
//            let linkUrlRequest = URLRequest(url: urlLink)
//            imageDownloader.download(linkUrlRequest, completion:  { response in
//                self.dispatchGroup.leave()
//                print(response.request)
//                print(response.response)
//                debugPrint(response.result)
//                
//                if case .success(let image) = response.result {
//                    print(image)
//                }
//                
//                completion(response.data)
//            })
        }
    }
    
    // MARK: Parsers
    func parseGalleriesData(data: Data?) -> Array<Gallery?> {
        guard let jsonData = data else {
            print("GalleriesData parser received nil data")
            return []
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        do{
            let responseData : GalleriesResponseData = try decoder.decode(GalleriesResponseData.self, from: jsonData)
            let galleriesList = responseData.galleryList
            for gallery in galleriesList {
                //Only fill images that cover is provided. Otherwise, cover image is nil, no need to request it
                if let currentGallery = gallery, let galleryImages = currentGallery.images {
                    let coverImage = galleryImages.filter { $0.id == currentGallery.cover }
                    if let coverImageFromGallery = coverImage.first {
                        currentGallery.coverImage = coverImageFromGallery
                        self.getImageDataFrom(link: coverImageFromGallery.isMp4Format() ? coverImageFromGallery.gifLink : coverImageFromGallery.link,completion: { (imageData) in
                            currentGallery.coverImage?.imageData = imageData
                        })
                    }
                }
            }
            return galleriesList
        }
        catch {
            print(error)
            return []
        }
    }
}
