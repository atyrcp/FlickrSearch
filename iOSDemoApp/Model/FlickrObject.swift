//
//  FlickrObjects.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/12.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation
//API call 回來的物件，雖然這個 App 只需要少數 property，但考量未來擴充性，還是全部都先接回來了
struct FlickrObject: Decodable {
    var photos: Photos
    var stat: String
}

struct Photos: Decodable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [FlickrPhoto]
}

struct FlickrPhoto: Decodable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
}
