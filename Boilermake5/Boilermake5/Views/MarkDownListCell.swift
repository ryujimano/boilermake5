//
//  MarkDownListCell.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 10/1/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class MarkDownListCell: UITableViewCell {
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var fileLabel: UILabel!

    func setUp(with fileName: String, fileImage: UIImage) {
        fileLabel.text = fileName
        fileImageView.image = fileImage
    }

}
