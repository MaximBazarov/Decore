//
//  AtomicState_BindTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class AtomicState_BindTests: XCTestCase {

    // MARK: - AtomicState -

    struct A: AtomicState {
        typealias Value = Int
        static var initialValue: () -> Value = { 0 }
    }

    let containerTested = A.self
    var write: Storage.Writer!
    var read: Storage.Reader!
    var storage: Storage!

    override func setUp() {
        storage = Storage()
        write = Storage.Writer(context: .here(), storage: storage)
        read = Storage.Reader(context: .here(), storage: storage)
    }

    // MARK: - Read -

    func test_Bind_read_InitialValue_shouldReturnInitialValue() throws {
        let expectedValue = A.initialValue()
        @Bind(containerTested, storage: storage) var result;
        XCTAssertEqual(result, expectedValue)
    }

    func test_Bind_read_WriteValue_shouldReturnWrittenValue() throws {
        let expectedValue = 7
        write(expectedValue, into: containerTested)
        @Bind(containerTested, storage: storage) var result;
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - Write -
    func test_Bind_write_storageReadsWrittenValue() throws {
        let expectedValue = 8
        @Bind(containerTested, storage: storage) var a;
        a = expectedValue
        XCTAssertEqual(read(containerTested), expectedValue)
    }


}
