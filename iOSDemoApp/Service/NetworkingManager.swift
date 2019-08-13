//
//  NetworkingManager.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/12.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation

class NetworkingManager {
    typealias completion = (_ flickrObjec: FlickrObject?, _ error: Error?) -> Void
    private var session: URLSession
    private let apiKey = "8ae89fbe8d2a0a93ab577e87d8ee2d2f"
    private let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&nojsoncallback=1"
    //拿圖片
    func getPhotos(with keyword: String, with amount: String, in page: String = "1", result: @escaping completion) {
        var regulateAmount = amount
        //偷偷設定讓 user 最多拿 30 張就好，collectionview 沒那麼大不用一次拿完，以增加讀取速度
        if let tempInt = Int(amount) {
            switch true {
            case tempInt > 30:
                regulateAmount = "30"
            default:
                break
            }
        }
        
        let endPoint = baseURL + "&api_key=\(apiKey)" + "&text=\(keyword)" + "&per_page=\(regulateAmount)" + "&page=\(page)" + "&format=json"
        guard let url = URL(string: endPoint) else {return}
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, _, error) in
            if error != nil {
                print(error.debugDescription)
                result(nil, error)
                return
            }
            guard let data = data, let flickrObject = try? JSONDecoder().decode(FlickrObject.self, from: data) else {return}
            result(flickrObject, nil)
        }
        task.resume()
    }
    //unit test mock 可能用到，先這樣寫
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}
