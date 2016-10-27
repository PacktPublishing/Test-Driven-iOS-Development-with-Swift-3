//
//  InputViewControllerTests.swift
//  ToDo
//
//  Created by dasdom on 24.07.16.
//  Copyright © 2016 dasdom. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

class InputViewControllerTests: XCTestCase {
  
  var sut: InputViewController!
  var placemark: MockPlacemark!

  override func setUp() {
    super.setUp()

    let storyboard = UIStoryboard(name: "Main",
                                  bundle: nil)
    sut = storyboard
      .instantiateViewController(
        withIdentifier: "InputViewController")
      as! InputViewController
    
    _ = sut.view
  }
  
  override func tearDown() {

    super.tearDown()
  }
  
  func test_HasTitleTextField() {
    XCTAssertNotNil(sut.titleTextField)
  }
  
  func test_HasDateTextField() {
    XCTAssertNotNil(sut.dateTextField)
  }
  
  func test_HasLocationTextField() {
    XCTAssertNotNil(sut.locationTextField)
  }
  
  func test_HasAddressTextField() {
    XCTAssertNotNil(sut.addressTextField)
  }
  
  func test_HasDescriptionTextField() {
    XCTAssertNotNil(sut.descriptionTextField)
  }
  
  func test_HasSaveButton() {
    XCTAssertNotNil(sut.saveButton)
  }
  
  func test_HasCancelButton() {
    XCTAssertNotNil(sut.cancelButton)
  }
  
  func test_Save_UsesGeocoderToGetCoordinateFromAddress() {
    let mockSut = MockInputViewController()
    
    mockSut.titleTextField = UITextField()
    mockSut.dateTextField = UITextField()
    mockSut.locationTextField = UITextField()
    mockSut.addressTextField = UITextField()
    mockSut.descriptionTextField = UITextField()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    
    let timestamp = 1456095600.0
    let date = Date(timeIntervalSince1970: timestamp)

    mockSut.titleTextField.text = "Foo"
    mockSut.dateTextField.text = dateFormatter.string(from: date)
    mockSut.locationTextField.text = "Bar"
    mockSut.addressTextField.text = "Infinite Loop 1, Cupertino"
    mockSut.descriptionTextField.text = "Baz"
    
    let mockGeocoder = MockGeocoder()
    mockSut.geocoder = mockGeocoder
    
    mockSut.itemManager = ItemManager()
    
    let dismissExpectation = expectation(description: "Dismiss")
    
    mockSut.completionHandler = {
      dismissExpectation.fulfill()
    }
    
    mockSut.save()
    
    placemark = MockPlacemark()
    let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
    placemark.mockCoordinate = coordinate
    mockGeocoder.completionHandler?([placemark], nil)
    
    waitForExpectations(timeout: 1, handler: nil)
    
    let item = mockSut.itemManager?.item(at: 0)
    
    let testItem = ToDoItem(title: "Foo",
                            itemDescription: "Baz",
                            timestamp: timestamp,
                            location: Location(name: "Bar", coordinate: coordinate))
    
    XCTAssertEqual(item, testItem)
    
    mockSut.itemManager?.removeAll()
  }

  func test_SaveButtonHasSaveAction() {
    let saveButton: UIButton = sut.saveButton
    
    guard let actions = saveButton.actions(
      forTarget: sut,
      forControlEvent: .touchUpInside) else {
        XCTFail(); return
    }
    
    XCTAssertTrue(actions.contains("save"))
  }
  
  func test_Geocoder_FetchesCoordinates() {
    let geocoderAnswered = expectation(description: "Geocoder")
    
    CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") {
      (placemarks, error) -> Void in
      
      let coordinate = placemarks?.first?.location?.coordinate
      guard let latitude = coordinate?.latitude else {
        XCTFail()
        return
      }
      
      guard let longitude = coordinate?.longitude else {
        XCTFail()
        return
      }
      
      XCTAssertEqualWithAccuracy(latitude, 37.3316, accuracy: 0.0001)
      XCTAssertEqualWithAccuracy(longitude, -122.0300, accuracy: 0.001)
      
      geocoderAnswered.fulfill()
    }
    
    waitForExpectations(timeout: 3, handler: nil)
  }
  
  func testSave_DismissesViewController() {
    let mockInputViewController = MockInputViewController()
    mockInputViewController.titleTextField = UITextField()
    mockInputViewController.dateTextField = UITextField()
    mockInputViewController.locationTextField = UITextField()
    mockInputViewController.addressTextField = UITextField()
    mockInputViewController.descriptionTextField = UITextField()
    mockInputViewController.titleTextField.text = "Test Title"
   
    mockInputViewController.save()
    
    XCTAssertTrue(mockInputViewController.dismissGotCalled)
  }

}

extension InputViewControllerTests {
  class MockGeocoder: CLGeocoder {
    
    var completionHandler: CLGeocodeCompletionHandler?
    
    override func geocodeAddressString(
      _ addressString: String,
      completionHandler: @escaping CLGeocodeCompletionHandler) {
      
      self.completionHandler = completionHandler
    }
  }
  
  class MockPlacemark : CLPlacemark {
    
    var mockCoordinate: CLLocationCoordinate2D?
    
    override var location: CLLocation? {
      guard let coordinate = mockCoordinate else
      { return CLLocation() }
      
      return CLLocation(latitude: coordinate.latitude,
                        longitude: coordinate.longitude)
    }
  }
  
  class MockInputViewController : InputViewController {
    
    var dismissGotCalled = false
    var completionHandler: (() -> Void)?
    
    override func dismiss(animated flag: Bool,
                          completion: (() -> Void)? = nil) {
      
      dismissGotCalled = true
      completionHandler?()
    }
  }

}

