//
//  FavoritesViewController.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/12.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit
//這頁面長得跟搜尋結果那個幾乎一樣，直接繼承
class FavoritesViewController: ResultViewController {
    //CoreData 用
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //移除我的最愛
    @objc func deleteFavorite(_ sender: FavoriteButton) {
        let savedPhoto = savedPhotos[sender.index]
        savedPhotos.remove(at: sender.index)
        collectionView.reloadData()
        context.delete(savedPhoto)
        appDelegate.saveContext()
        let alert = UIAlertController(title: "刪除成功", message: "已從我的最愛移除", preferredStyle: .alert)
        let action = UIAlertAction(title: "好", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的最愛"
    }
    //切換到本頁時先去 CoreData 中撈撈看有沒有已經存好的圖片
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            savedPhotos = try context.fetch(SavedPhoto.fetchRequest())
            collectionView.reloadData()
        } catch {
            let error = error as Error
            print(error)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.nibName(), for: indexPath) as? ResultCell else {return UICollectionViewCell()}
        
        let savedPhoto = savedPhotos[indexPath.item]
        let photo = Photo(imageUrl: savedPhoto.imageUrl ?? "", title: savedPhoto.title ?? "")
        cell.setOutlet(from: photo)
        cell.setProperty(from: photo, in: indexPath)
        cell.favoriteButton.addTarget(self, action: #selector(deleteFavorite(_:)), for: .touchUpInside)
        return cell
    }
}


