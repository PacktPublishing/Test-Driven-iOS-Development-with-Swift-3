//
//  ItemListViewControllerTests.swift
//  ToDo
//
//  Created by dasdom on 22.07.16.
//  Copyright © 2016 dasdom. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {
  
  var sut: ItemListViewController!
  
  override func setUp() {
    super.setUp()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(
      withIdentifier: "ItemListViewController")
    sut = viewController as! ItemListViewController
    
    _ = sut.view
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_TableView_AfterViewDidLoad_IsNotNil() {
    XCTAssertNotNil(sut.tableView)
  }
  
  func test_LoadingView_SetsTableViewDataSource() {
    XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
  }
  
  func test_LoadingView_SetsTableViewDelegate() {
    XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
  }
  
  func test_LoadingView_SetsDataSourceAndDelegateToSameObject() {
    XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider,
                   sut.tableView.delegate as? ItemListDataProvider)
  }
}
