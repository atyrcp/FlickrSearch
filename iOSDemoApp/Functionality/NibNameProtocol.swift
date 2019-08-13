//
//  NibNameProtocol.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/12.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation
import UIKit
//減少 hard coding，避免打錯字
protocol NibNameProtocol {
    
}

extension NibNameProtocol where Self: UIView {
    static func nibName() -> String {
        return String(describing: Self.self)
    }
}
