//
//  SortTest.swift
//  SearchListTests
//
//  Created by chungeunji on 2021/06/22.
//

import XCTest
@testable import SearchList

class SortTest: XCTestCase {

    var sut: AppendOperation!

    override func setUp() {
        sut = AppendOperation(originList: [])
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSorting_givenList_sortList() throws {
        // given
        let expected: [String] = expectedDocs.compactMap({ $0.title })
        let expectation = expectation(description: "Sorting")
        // when
        var result: [String] = []
        sut.newList = givenDocuments
        let sort = SortOperation(sort: .title) { _, _, list in
            result = list.compactMap({ $0.parsedTitle })
            expectation.fulfill()
        }
        sut.addDependency(sort)

        let operations = [sut, sort]
//        OperationQueue().addOperations(operations, waitUntilFinished: false)

        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(expected, result)
    }

}
