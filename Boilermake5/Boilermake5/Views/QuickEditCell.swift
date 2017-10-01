//
//  QuickEditCell.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class QuickEditCell: UICollectionViewCell {
    @IBOutlet weak var quickLabel: UILabel!

    func setUp(with quickEdit: String) {
        quickLabel.text = quickEdit
    }
}
