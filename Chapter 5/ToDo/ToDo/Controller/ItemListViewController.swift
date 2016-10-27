//
//  ItemListViewController.swift
//  ToDo
//
//  Created by dasdom on 22.07.16.
//  Copyright © 2016 dasdom. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate)!

  override func viewDidLoad() {
    tableView.dataSource = dataProvider
    tableView.delegate = dataProvider
  }
}
