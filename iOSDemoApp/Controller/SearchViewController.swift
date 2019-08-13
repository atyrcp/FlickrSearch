//
//  SearchViewController.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/12.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    let networkingManager = NetworkingManager()
    var searchView: SearchView?
    var activityIndicator: UIActivityIndicatorView?
    var photos = [Photo]()
    
    func customSetup() {
        //設定 xib 檔的 searchView AutoLayout
        let searchView = SearchView()
        self.searchView = searchView
        self.view.addSubview(searchView)
        searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        searchView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        
        //將searchView 中的 function 邏輯拉到 viewController 做
        searchView.searchButton.addTarget(self, action: #selector(searchPhotos), for: .touchUpInside)
        
        //設定標題
        self.title = "搜尋輸入頁"
        
        //設定讀取圖示
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        self.view.addSubview(activityIndicator!)
        activityIndicator!.center = self.view.center
        activityIndicator?.color = .red
        activityIndicator?.hidesWhenStopped = true
        self.view.bringSubviewToFront(activityIndicator!)
    }
    
    //搜尋功能
    @objc func searchPhotos() {
        //開始搜尋的時候先轉一下告訴 user App有在動了等一下啦別亂動
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
        //拿 textField 上的文字帶入搜尋
        let keyword = searchView?.searchKeywordTextField.text ?? ""
        let amount = searchView?.searchAmountTextField.text ?? ""
        
        networkingManager.getPhotos(with: keyword, with: amount) { (flickrObject, error) in
            //搜尋失敗的 UI
            if error != nil {
                DispatchQueue.main.async {
                    self.activityIndicator?.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            //搜尋成功
            } else {
                let photos = flickrObject!.photos.photo
                for flickrPhoto in photos {
                    print(flickrPhoto.title)
                    let title = flickrPhoto.title
                    let url = "https://farm\(flickrPhoto.farm).staticflickr.com/\(flickrPhoto.server)/\(flickrPhoto.id)_\(flickrPhoto.secret)_m.jpg"
                    let photo = Photo(imageUrl: url, title: title)
                    self.photos.append(photo)
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showResult", sender: nil)
                }
            }
        }
    }
    //把搜尋結果傳到下一頁，並註明一下搜尋關鍵字
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewContrller = segue.destination as? ResultViewController
        destinationViewContrller?.photos = self.photos
        destinationViewContrller?.currentKeyword = searchView?.searchKeywordTextField.text! ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup()
    }
    //離開畫面時記得把 activityIndicator 停掉，並清空搜尋結果，以便下一次返回時拿到可以重新搜尋
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        photos = [Photo]()
        
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
}
