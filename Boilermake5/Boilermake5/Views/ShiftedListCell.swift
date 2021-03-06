//
//  ShiftedListCell.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

enum ShiftedLevel: CGFloat {
    case zero = 8.0
    case first = 20.0
    case second = 32.0
    case third = 44.0
    case fourth = 56.0
    case fifth = 68.0
}

class ShiftedListCell: UITableViewCell {
    @IBOutlet weak var bulletLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentBackViewLeadingConstraint: NSLayoutConstraint!

    func setUp(with bullet: NSAttributedString?, contentText: NSAttributedString, shiftedLevel: ShiftedLevel) {
        contentBackViewLeadingConstraint.constant = shiftedLevel.rawValue
        bulletLabel.attributedText = bullet
        contentLabel.attributedText = contentText
    }
}
