// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import XCTest
import WikiMov

class WikiMovLocalStoreIntegrationTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    setupEmptyStoreState()
  }
  
  override func tearDown() {
    super.tearDown()
    
    undoStoreSideEffects()
  }
  
  func test_load_deliversNoDataOnEmptyStore() {
    let sut = makeSUT()
    
    expect(sut, toLoad: [])
  }
  
  func test_load_deliversDataSavedOnSeparateInstance() {
    let sutToPerformSave = makeSUT()
    let sutToPerformLoad = makeSUT()
    let data = uniqueLocalMovie()
    
    save(data, with: sutToPerformSave)
    
    expect(sutToPerformLoad, toLoad: [data])
  }
  
  func test_load_deliversTwoDatasOnTwoSuccessfulInsertion() {
    let sutToPerformFirstSave = makeSUT()
    let sutToPerformSecondSave = makeSUT()
    let sutToPerformLoad = makeSUT()
    let firstData = uniqueLocalMovie()
    let secondData = uniqueLocalMovie()
   
    save(firstData, with: sutToPerformFirstSave)
    save(secondData, with: sutToPerformSecondSave)
    
    expect(sutToPerformLoad, toLoad: [firstData, secondData])
  }
  
  
  // MARK: - Helpers
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> DefaultLocalMovieLoader {
    let storeURL = testSpecificStoreURL()
    let store = try! CoreDataLocalMovieStore(storeURL: storeURL)
    let sut = DefaultLocalMovieLoader(store: store)
    trackForMemoryLeaks(for: store, file: file, line: line)
    trackForMemoryLeaks(for: sut, file: file, line: line)
    return sut
  }
  
  private func save(_ data: LocalMovie, with sut: DefaultLocalMovieLoader, file: StaticString = #filePath, line: UInt = #line) {
    
    let exp = expectation(description: "Wait for save completion.")
    sut.save(data) { error in
      XCTAssertNil(error, "Expected to save data successfully", file: file, line: line)
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
  
  private func expect(_ sut: DefaultLocalMovieLoader, toLoad expectedData: [LocalMovie], file: StaticString = #filePath, line: UInt = #line) {
    let exp = expectation(description: "Wait for load completion.")
    
    sut.load { result in
      switch result {
      case let .success(receivedData):
        XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        
      case let .failure(error):
        XCTFail("Expected to retrieve non-empty data, but got \(error) instead.", file: file, line: line)
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
  
  private func testSpecificStoreURL() -> URL {
    return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
  }
  
  private func cachesDirectory() -> URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
  }
  
  private func deleteStoreArtifacts() {
    try? FileManager.default.removeItem(at: testSpecificStoreURL())
  }
  
  private func setupEmptyStoreState() {
    deleteStoreArtifacts()
  }
  
  private func undoStoreSideEffects() {
    deleteStoreArtifacts()
  }
}
