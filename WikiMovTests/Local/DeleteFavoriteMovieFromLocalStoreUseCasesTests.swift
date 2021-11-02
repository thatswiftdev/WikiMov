// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import XCTest
import WikiMov

class DeleteFavoriteMovieFromLocalStoreUseCasesTests: XCTestCase {
  
  func test_init_doestNotMessageStoreUponCreation() {
    let (_, store) = makeSUT()
    
    XCTAssertEqual(store.receivedMessages, [])
  }
  
  func test_delete_messageTheStore() {
    let (sut, store) = makeSUT()
    let data = uniqueLocalMovie()
    
    sut.delete(data) { _ in }
    
    XCTAssertEqual(store.receivedMessages, [.delete(data)])
  }
  
  func test_delete_failsOnDeletionError() {
    let (sut, store) = makeSUT()
    let data = uniqueLocalMovie()
    
    let exp = expectation(description: "Wait for deletion completion")
    sut.delete(data) { error in
      exp.fulfill()
    }
    
    store.completeDeletion(with: anyNSError())
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_delete_succeedsOnSuccessfulDataDeletion() {
    let (sut, store) = makeSUT()
    let data = uniqueLocalMovie()

    let exp = expectation(description: "Wait for deletion completion")
    sut.delete(data) { error in
      exp.fulfill()
    }

    store.completeDeletionSuccessfully()
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_delete_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
    let store = LocalMovieStoreSpy()
    var sut: DefaultLocalMovieLoader? = DefaultLocalMovieLoader(store: store)
    
    var receivedResult = [DefaultLocalMovieLoader.SaveResult]()
    
    sut?.delete(uniqueLocalMovie()) { receivedResult.append($0) }
    
    sut = nil
    
    store.completeDeletion(with: anyNSError())
    
    XCTAssertTrue(receivedResult.isEmpty)
  }
  
  // MARK: - Helpers
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: DefaultLocalMovieLoader, store: LocalMovieStoreSpy) {
    let store = LocalMovieStoreSpy()
    let sut = DefaultLocalMovieLoader(store: store)
    trackForMemoryLeaks(for: store, file: file, line: line)
    trackForMemoryLeaks(for: sut, file: file, line: line)
    
    return (sut, store)
  }
}

