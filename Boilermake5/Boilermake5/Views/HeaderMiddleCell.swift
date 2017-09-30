//
//  HeaderMiddleCell.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class HeaderMiddleCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!

    func setUp(with contentText: String) {
        contentLabel.text = contentText
    }
}
