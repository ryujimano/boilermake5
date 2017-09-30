//
//  MarkDownHeader.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import Foundation

enum MarkDownHeaderSize: CGFloat {
    case h1 = 28.0
    case h2 = 26.0
    case h3 = 24.0
    case h4 = 22.0
    case h5 = 20.0
    case h6 = 18.0
}

struct MarkDownHeader {
    var header: String
    var contents: [String]
    var size: MarkDownHeaderSize
}
