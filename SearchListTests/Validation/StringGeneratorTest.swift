//
//  StringGeneratorTest.swift
//  SearchListTests
//
//  Created by chungeunji on 2021/06/22.
//

import XCTest
@testable import SearchList

class StringGeneratorTest: XCTestCase {

//    var sut: EJShowClothViewModel!
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testStringGenerator_parseTitle_removedHtml() throws {
        // given
        let given = "<b>아이유</b>를 이용하고 버린 연예인 A씨"
        let expected = "아이유를 이용하고 버린 연예인 A씨"
        // when
        guard let result = given.removeHtml else { return }
        // then
        XCTAssertEqual(expected, result)
    }

}
