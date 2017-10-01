//
//  MarkDownListController.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import FontAwesomeKit
import TesseractOCR

class MarkDownListController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(cellType: MarkDownListCell.self)
            tableView.register(cellType: NoFilesCell.self)
        }
    }

    var files: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.cameraIcon(withSize: 28.0).image(with: CGSize(width: 32.0, height: 32.0)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(MarkDownListController.openPhotos))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.plusIcon(withSize: 28.0).image(with: CGSize(width: 32.0, height: 32.0)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(MarkDownListController.addEntry))

        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7137254902, green: 0.7215686275, blue: 0.8392156863, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7137254902, green: 0.7215686275, blue: 0.8392156863, alpha: 1)

        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7411764706, green: 0.9294117647, blue: 0.8784313725, alpha: 1)

        tableView.reloadData()
    }

    @objc func openPhotos() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            controller.sourceType = .camera
        } else {
            controller.sourceType = .photoLibrary
        }
        present(controller, animated: true)
    }

    @objc func addEntry() {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ParsedMarkDownController {
            if let sender = sender as? String {
                destination.md = sender
            }
        }
    }

}

extension MarkDownListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if !files.isEmpty {
            performSegue(withIdentifier: "toView", sender: files[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if files.isEmpty {
            return NoFilesCell.cellHeight()
        }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension MarkDownListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.isEmpty ? 1 : files.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if files.isEmpty {
            let cell = tableView.dequeueReuseableCell(with: NoFilesCell.self, for: indexPath)
            cell.setUp()
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReuseableCell(with: MarkDownListCell.self, for: indexPath)
        let str = files[indexPath.row]
        cell.setUp(with: String(str[str.startIndex...str.index(str.startIndex, offsetBy: min(str.count, 20))]), fileImage: FAKFontAwesome.fileTextIcon(withSize: 40.0).image(with: CGSize(width: 70, height: 70)))
        return cell
    }
}

extension MarkDownListController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let original = info[UIImagePickerControllerOriginalImage] as? UIImage, let edited = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }

        dismiss(animated: true, completion: {
            let tesseract = G8Tesseract(language: "eng")
            tesseract?.engineMode = .tesseractCubeCombined

            tesseract?.pageSegmentationMode = .auto

            tesseract?.maximumRecognitionTime = 60.0

            tesseract?.image = edited.g8_blackAndWhite()
            tesseract?.recognize()

            if let text = tesseract?.recognizedText {
                self.files.append(text)
            }
        })
    }
}

extension MarkDownListController: G8TesseractDelegate {
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return false
    }
}
