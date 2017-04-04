//
//  DetailViewControllerTests.swift
//  ToDo
//
//  Created by dasdom on 24.07.16.
//  Copyright © 2016 dasdom. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

class DetailViewControllerTests: XCTestCase {
  
  var sut: DetailViewController!
  
  override func setUp() {
    super.setUp()

    let storyboard = UIStoryboard(name: "Main",
                                  bundle: nil)
    sut = storyboard
      .instantiateViewController(
        withIdentifier: "DetailViewController")
      as! DetailViewController
    _ = sut.view
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_HasTitleLabel() {
    XCTAssertNotNil(sut.titleLabel)
  }
  
  func test_HasDateLabel() {
    XCTAssertNotNil(sut.dateLabel)
  }
  
  func test_HasLocationLabel() {
    XCTAssertNotNil(sut.locationLabel)
  }
  
  func test_HasDescriptionLabel() {
    XCTAssertNotNil(sut.descriptionLabel)
  }
  
  func test_HasMapView() {
    XCTAssertNotNil(sut.mapView)
  }
  
  func test_SettingItemInfo_SetsTextsToLabels() {
    let coordinate = CLLocationCoordinate2DMake(51.2277, 6.7735)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    
    let date = dateFormatter.date(from: "02/22/2016")!
    let timestamp = date.timeIntervalSince1970
    
    let location = Location(name: "Foo", coordinate: coordinate)
    let item = ToDoItem(title: "Bar",
                        itemDescription: "Baz",
                        timestamp: timestamp,
                        location: location)
    
    let itemManager = ItemManager()
    itemManager.add(item)
    
    sut.itemInfo = (itemManager, 0)
    
    sut.beginAppearanceTransition(true, animated: true)
    sut.endAppearanceTransition()
    
    XCTAssertEqual(sut.titleLabel.text, "Bar")
    XCTAssertEqual(sut.dateLabel.text, dateFormatter.string(from: date))
    XCTAssertEqual(sut.locationLabel.text, "Foo")
    XCTAssertEqual(sut.descriptionLabel.text, "Baz")
    XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.latitude,
                               coordinate.latitude,
                               accuracy: 0.001)
    XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.longitude,
                               coordinate.longitude,
                               accuracy: 0.001)

  }
  
  func test_CheckItem_ChecksItemInItemManager() {
    let itemManager = ItemManager()
    itemManager.add(ToDoItem(title: "Foo"))
    
    sut.itemInfo = (itemManager, 0)

    sut.checkItem()
    
    XCTAssertEqual(itemManager.toDoCount, 0)
    XCTAssertEqual(itemManager.doneCount, 1)
  }
}
