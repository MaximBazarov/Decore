//
//  BindGroup_Tests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore
import DecoreTesting

let GroupStateUnderTess = GroupState<Int, Int> {_ in 0 }



final class StorageAttach_Tests: XCTestCase {


    func test_BindGroup_defaultValue_shouldReturnDefaultValue() throws {
        let storage = Storage()
        @BindGroup(GroupStateUnderTess, storage: storage) var sut;
        XCTAssertEqual(sut[0], 0)
    }

    func test_BindGroup_writeValue_shouldReturnWrittenValue() throws {
        let storage = Storage()
        let id = 1
        let expected = 9
        @BindGroup(GroupStateUnderTess, storage: storage) var sut;
        sut[id] = expected
        XCTAssertEqual(sut[id], expected)
    }
}
