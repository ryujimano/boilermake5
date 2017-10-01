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

    func setUp(with header: MarkDownHeader) {
        headerLabel.text = header.header
        headerLabel.font = UIFont.boldSystemFont(ofSize: header.size.rawValue)
        separatorView.isHidden = !(header.size == .h1 || header.size == .h2)
    }
}
