//
//  HeaderCell.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

    func setUp(with separator: Bool, size: MarkDownHeaderSize, header: String) {
        headerLabel.text = header
        headerLabel.font = UIFont.systemFont(ofSize: CGFloat(size.rawValue))
        separatorView.isHidden = !separator
    }
}
