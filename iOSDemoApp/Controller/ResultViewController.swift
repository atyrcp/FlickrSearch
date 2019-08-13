//
//  ResultViewController.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/12.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    //CoreData 用的
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //傳來的搜尋結果
    var photos = [Photo]()
    //這傳來的搜尋關鍵字
    var currentKeyword = ""
    //不管 user 前一次搜尋多少張，已經寫死最多30(反正 user 看不出來)，滑動時一次讀取10張，從第4頁開始(也就是第31張)，盡可能不會出現同樣的圖片
    var currentPage = 4
    //CoreData 儲存用
    var savedPhotos = [SavedPhoto]()
    
    //儲存到我的最愛
    @objc func favorite(_ sender: FavoriteButton) {
        let savedPhoto = SavedPhoto(entity: SavedPhoto.entity(), insertInto: context)
        savedPhoto.imageUrl = sender.imageUrl
        savedPhoto.title = sender.title
        savedPhotos.append(savedPhoto)
        appDelegate.saveContext()
        let alert = UIAlertController(title: "儲存成功", message: "已新增到我的最愛", preferredStyle: .alert)
        let action = UIAlertAction(title: "好", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func customSetup() {
        let nib = UINib(nibName: ResultCell.nibName(), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ResultCell.nibName())
        self.title = "搜尋結果 \(currentKeyword)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup()
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.nibName(), for: indexPath) as? ResultCell else {return UICollectionViewCell()}
        
        let photo = photos[indexPath.item]
        cell.setOutlet(from: photo)
        cell.setProperty(from: photo, in: indexPath)
        cell.favoriteButton.addTarget(self, action: #selector(favorite(_:)), for: .touchUpInside)
        
        return cell
    }
    //往下快滑到底的時候去讀取圖片
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == photos.count - 2 {
            let networkingManager = NetworkingManager()
            
            networkingManager.getPhotos(with: currentKeyword, with: "10", in: String(currentPage)) { (flickrObject, _) in
                self.currentPage += 1
                
                let photos = flickrObject!.photos.photo
                for flickrPhoto in photos {
                    let title = flickrPhoto.title
                    let url = "https://farm\(flickrPhoto.farm).staticflickr.com/\(flickrPhoto.server)/\(flickrPhoto.id)_\(flickrPhoto.secret)_m.jpg"
                    let photo = Photo(imageUrl: url, title: title)
                    self.photos.append(photo)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension ResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.bounds.width - 32) / 2
        let height = width * 1.2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}
