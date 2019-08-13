//
//  Extensions.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/13.
//  Copyright © 2019 z. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func contentOfURL(url: String) -> UIImage? {
        guard let url = URL(string: url), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {return nil}
        return image
    }
}
