//
//  ImageCell.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var imageURLLabel: UILabel!

    func setUp(with imageURLString: String) {
        stackView.arrangedSubviews[1].isHidden = true
        cellImageView.kf.setImage(with: URL(string: imageURLString), placeholder: nil, options: nil, progressBlock: nil) { (image, error, _, _) in
            if error == nil || image == nil {
                self.stackView.arrangedSubviews[1].isHidden = false
                self.imageURLLabel.text = imageURLString
                self.stackView.arrangedSubviews[0].isHidden = true
            } else {
                self.stackView.arrangedSubviews[1].isHidden = true
                self.stackView.arrangedSubviews[0].isHidden = false
            }
        }
    }
}
