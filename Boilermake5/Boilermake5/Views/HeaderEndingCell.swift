//
//  HeaderEndingCell.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class HeaderEndingCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentBackView: UIView!
    @IBOutlet weak var stackView: UIStackView!

    func setUp(with content: Bool, contentText: String) {
        if content {
            stackView.arrangedSubviews[0].isHidden = false
            contentLabel.text = contentText
        } else {
            stackView.arrangedSubviews[0].isHidden = true
        }
    }
}
