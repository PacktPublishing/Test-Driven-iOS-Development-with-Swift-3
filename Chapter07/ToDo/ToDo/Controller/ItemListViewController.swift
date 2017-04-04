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
  @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
  let itemManager = ItemManager()
  
  override func viewDidLoad() {
    tableView.dataSource = dataProvider
    tableView.delegate = dataProvider
    dataProvider.itemManager = itemManager
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(showDetails(sender:)),
      name: NSNotification.Name("ItemSelectedNotification"),
      object: nil)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.reloadData()
  }
  
  @IBAction func addItem(_ sender: AnyObject) {
    if let nextViewController =
      storyboard?.instantiateViewController(
        withIdentifier: "InputViewController")
        as? InputViewController {
      
      nextViewController.itemManager = self.itemManager
      present(nextViewController, animated: true, completion: nil)
    }
  }
  
  func showDetails(sender: NSNotification) {
    guard let index = sender.userInfo?["index"] as? Int else
    { fatalError() }
    
    if let nextViewController = storyboard?.instantiateViewController(
      withIdentifier: "DetailViewController") as? DetailViewController {
      
      nextViewController.itemInfo = (itemManager, index)
      navigationController?.pushViewController(nextViewController,
                                               animated: true)
    }
  }

}
