//
//  Common.swift
//  VK
//
//  Created by  Sergei on 09.03.2021.
//

import UIKit

extension Array where Element == Int {

    var indexPaths: [IndexPath] {
        self.map { IndexPath(item: $0, section: 0) }
    }

}
