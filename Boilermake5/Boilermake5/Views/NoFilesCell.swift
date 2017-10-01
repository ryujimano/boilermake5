//
//  NoFilesCell.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 10/1/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import FontAwesomeKit

class NoFilesCell: UITableViewCell {
    @IBOutlet weak var noEntryView: UIImageView!

    func setUp() {
        noEntryView.image = FAKFontAwesome.folderOpenOIcon(withSize: 90.0).image(with: CGSize(width: 108.0, height: 108.0))
    }

    static func cellHeight() -> CGFloat {
        return 280.0
    }
    
}
