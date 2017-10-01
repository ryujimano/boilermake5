//
//  EditController.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

fileprivate let quickEdits: [String] = ["# ", "- ", "* ", "1. "]

class EditController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(QuickEditCell.self)
        }
    }
    @IBOutlet weak var collectionViewToBottomConstraint: NSLayoutConstraint!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(EditController.saveButtonTapped))

        NotificationCenter.default.addObserver(self, selector: #selector(EditController.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditController.keyboardWillResign), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        collectionViewToBottomConstraint.constant = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGFloat ?? 0.0
    }

    @objc func keyboardWillResign () {
        collectionViewToBottomConstraint.constant = 0.0
    }

    @objc func saveButtonTapped() {


        self.navigationController?.popViewController(animated: true)
    }

}

extension EditController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        textView.text.append(quickEdits[indexPath.item])
    }
}

extension EditController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let quickLabel = UILabel()
        quickLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        quickLabel.text = quickEdits[indexPath.item]
        quickLabel.sizeToFit()
        return CGSize(width: quickLabel.bounds.width + 24.0, height: 34.0)
    }
}

extension EditController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quickEdits.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: QuickEditCell.self, for: indexPath)
        cell.setUp(with: quickEdits[indexPath.item])
        return cell
    }
}
