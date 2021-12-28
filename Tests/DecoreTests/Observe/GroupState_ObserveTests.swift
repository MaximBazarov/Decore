//
//  GroupState_ObserveTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class GroupState_ObserveTests: XCTestCase {

    struct G: GroupState {
        typealias Element = Int
        typealias ID = Int
        static func initialValue(for id: Int) -> Int { 0 }
    }

    let containerTested = G.self
    var write: Storage.Writer!
    var storage: Storage!

    override func setUp() {
        storage = Storage()
        write = Storage.Writer(context: .here(), storage: storage)
    }

    // MARK: - Read -

    func test_Bind_read_InitialValue_shouldReturnInitialValue() throws {
        let id = 1
        let expectedValue = G.initialValue(for: id)
        @Observe(containerTested, storage: storage) var result;
        XCTAssertEqual(result[id], expectedValue)
    }

    func test_Bind_read_WriteValue_shouldReturnWrittenValue() throws {
        let id = 2
        let expectedValue = 9
        write(expectedValue, into: containerTested, at: id)
        @Observe(containerTested, storage: storage) var result;
        XCTAssertEqual(result[id], expectedValue)
    }


}
