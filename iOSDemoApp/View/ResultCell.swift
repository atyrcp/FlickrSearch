//
//  ResultCell.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/12.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class ResultCell: UICollectionViewCell, NibNameProtocol {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    //設定 cell 外觀
    func setOutlet(from photo: Photo) {
        nameLabel.text = photo.title
        if let image = UIImage.contentOfURL(url: photo.imageUrl) {
            self.imageView.image = image
        }
    }
    //設定 透過客製化的 button 傳值，所以進行一些設定
    func setProperty(from photo: Photo, in indexPath: IndexPath) {
        favoriteButton.imageUrl = photo.imageUrl
        favoriteButton.title = photo.title
        favoriteButton.index = indexPath.item
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
