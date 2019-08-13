//
//  FavoriteButton.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/13.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit
//客製化在 cell 右上角的加入(移除)我的最愛 button，點選時需要知道 cell 資訊，所以新增一些 property 用來辨別是哪個 cell 順便傳值
class FavoriteButton: UIButton {
    var imageUrl: String = ""
    var title: String = ""
    var index: Int = 0
}
