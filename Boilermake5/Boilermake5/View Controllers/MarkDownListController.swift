//
//  MarkDownListController.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import FontAwesomeKit

class MarkDownListController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(cellType: MarkDownListCell.self)
        }
    }

    var files = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Import", style: .plain, target: self, action: #selector(MarkDownListController.openPhotos))

        tableView.reloadData()
    }

    func openPhotos() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            controller.sourceType = .camera
        } else {
            controller.sourceType = .photoLibrary
        }
    }

}

extension MarkDownListController: UITableViewDelegate {

}

extension MarkDownListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReuseableCell(with: MarkDownListCell.self, for: indexPath)
        cell.setUp(with: "", fileImage: FAKFontAwesome.fileTextIcon(withSize: 40.0).image(with: CGSize(width: 70, height: 70)))
        return cell
    }
}

extension MarkDownListController: UIImagePickerControllerDelegate, UINavigationBarDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let original = info[UIImagePickerControllerOriginalImage] as? UIImage, let edited = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }

        

        dismiss(animated: true, completion: nil);
    }
}
