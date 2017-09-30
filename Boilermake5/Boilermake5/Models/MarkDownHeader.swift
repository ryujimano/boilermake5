//
//  MarkDownHeader.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import Foundation

enum MarkDownHeaderSize {
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
}

struct MarkDownHeader {
    var header: String
    var contents: [String]
    var size: MarkDownHeaderSize
}
