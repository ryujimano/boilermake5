//
//  ParsedMarkDownController.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import FontAwesomeKit

class ParsedMarkDownController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(cellType: HeaderCell.self)
            tableView.register(cellType: HeaderEndingCell.self)
            tableView.register(cellType: HeaderMiddleCell.self)
            tableView.register(cellType: ImageCell.self)
            tableView.register(cellType: ShiftedListCell.self)
            tableView.register(cellType: BlankCell.self)
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 40.0
        }
    }

    var md: String?
    var headers: [MarkDownHeader] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let mark = """
//    this is text
//this is another text
//this is third text
//
//"""
//        MarkDownParser.shared.parse(markdown: mark).forEach {
//            print($0)
//        }
////        print()
//        MarkDownParser.shared.parse(url: URL(string: "https://raw.githubusercontent.com/ryujimano/cs251/master/project1/README.md?token=AIbZ7d_s-3FsgJ2gpJscoH12JTONHGn6ks5Z2O9ywA%3D%3D")!, success: { (headers) in
//            headers.forEach {
//                print($0)
//            }
//            self.headers = headers
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        guard let md = md else {
            self.navigationController?.popViewController(animated: true)
            return
        }

        headers = MarkDownParser.shared.parse(markdown: md)
        tableView.reloadData()
    }

}

extension ParsedMarkDownController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if headers[indexPath.section].contents.count > indexPath.row && headers[indexPath.section].contents[indexPath.row].contentText.isEmpty {
            return CGFloat.leastNormalMagnitude
        }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

extension ParsedMarkDownController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (headers[section].header != nil ? 1 : 0) + headers[section].contents.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if headers[indexPath.section].header != nil  && indexPath.row == 0 {
            let cell = tableView.dequeueReuseableCell(with: HeaderCell.self, for: indexPath)
            cell.setUp(with: headers[indexPath.section])
            cell.selectionStyle = .none
            return cell
        }

        if indexPath.row >= headers[indexPath.section].contents.count - 1 {
            let cell = tableView.dequeueReuseableCell(with: HeaderEndingCell.self, for: indexPath)
            cell.setUp(with: false, contentText: "")
            cell.selectionStyle = .none
            return cell
        }
        let content = headers[indexPath.section].contents[indexPath.row]
        let (element, attributedString, bullet, imageURL) = MarkDownParser.shared.parseElement(for: content)
        if attributedString.string.isEmpty {
            let cell = tableView.dequeueReuseableCell(with: BlankCell.self, for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        switch element {
        case MarkDownElement.image:
            let cell = tableView.dequeueReuseableCell(with: ImageCell.self, for: indexPath)
            cell.setUp(with: imageURL)
            cell.selectionStyle = .none
            return cell
        case MarkDownElement.list(let level):
            let cell = tableView.dequeueReuseableCell(with: ShiftedListCell.self, for: indexPath)
            cell.setUp(with: bullet, contentText: attributedString, shiftedLevel: level)
            cell.selectionStyle = .none
            return cell
        case MarkDownElement.orderedList(let level):
            let cell = tableView.dequeueReuseableCell(with: ShiftedListCell.self, for: indexPath)
            cell.setUp(with: bullet, contentText: attributedString, shiftedLevel: level)
            cell.selectionStyle = .none
            return cell
        case MarkDownElement.paragraph:
            fallthrough
        default:
            let cell = tableView.dequeueReuseableCell(with: HeaderMiddleCell.self, for: indexPath)
            cell.setUp(with: attributedString)
            cell.selectionStyle = .none
            return cell
        }
    }
}
