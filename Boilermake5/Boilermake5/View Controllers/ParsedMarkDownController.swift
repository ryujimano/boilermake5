//
//  ParsedMarkDownController.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 9/30/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

enum Section: Int {
    case count
}

class ParsedMarkDownController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ParsedMarkDownController: UITableViewDelegate {

}

extension ParsedMarkDownController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.cellForRow(at: indexPath)
    }
}
