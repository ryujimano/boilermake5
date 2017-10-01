//
//  ParsedMarkDownController.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class ParsedMarkDownController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
//            tableView.delegate = self
//            tableView.dataSource = self
            tableView.register(cellType: HeaderCell.self)
            tableView.register(cellType: HeaderEndingCell.self)
            tableView.register(cellType: HeaderMiddleCell.self)
            tableView.register(cellType: ImageCell.self)
            tableView.register(cellType: ShiftedListCell.self)
        }
    }

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
//        print()
        MarkDownParser.shared.parse(url: URL(string: "https://raw.githubusercontent.com/ryujimano/cs251/master/project1/README.md?token=AIbZ7d_s-3FsgJ2gpJscoH12JTONHGn6ks5Z2O9ywA%3D%3D")!, success: { (headers) in
            headers.forEach {
                print($0)
            }
            self.headers = headers
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}

extension ParsedMarkDownController: UITableViewDelegate {

}

extension ParsedMarkDownController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headers[section].header != nil ? 1 : 0 + headers[section].contents.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let content = headers[indexPath.section].contents[indexPath.row]
        let (element, attributedString, imageURL) = MarkDownParser.shared.parseElement(for: content)
        switch element {
        case MarkDownElement.image:
            let cell = tableView.dequeueReuseableCell(with: ImageCell.self, for: indexPath)
        case MarkDownElement.list(let level):
            let cell = tableView.dequeueReuseableCell(with: ShiftedListCell.self, for: indexPath)
        case MarkDownElement.orderedList(let level):
            let cell = tableView.dequeueReuseableCell(with: ShiftedListCell.self, for: indexPath)
        case MarkDownElement.paragraph:
            if headers[indexPath.section].contents.count - 1 == indexPath.row {
                let cell = tableView.dequeueReuseableCell(with: HeaderEndingCell.self, for: indexPath)
            } else {
                let cell = tableView.dequeueReuseableCell(with: HeaderMiddleCell.self, for: indexPath)
            }
        default:
            let cell = tableView.dequeueReuseableCell(with: HeaderCell.self, for: indexPath)


        }
    }
}
