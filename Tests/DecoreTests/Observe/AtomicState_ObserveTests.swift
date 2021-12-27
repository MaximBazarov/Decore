//
//  AtomicState_ObserveTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class AtomicState_ObserveTests: XCTestCase {

    // MARK: - AtomicState -

    struct A: AtomicState {
        typealias Value = Int
        static var initialValue: () -> Value = { 0 }
    }

    let containerTested = A.self
    var write: Storage.Writer!
    var storage: Storage!

    override func setUp() {
        storage = Storage()
        write = Storage.Writer(context: .here(), storage: storage)
    }

    // MARK: - Read -

    func test_Observe_AtomicState_InitialValue_shouldReturnInitialValue() throws {
        let expectedValue = A.initialValue()
        @Observe(containerTested, storage: storage) var result;
        XCTAssertEqual(result, expectedValue)
    }

    func test_Observe_AtomicState_WrittenValue_shouldReturnWrittenValue() throws {
        let expectedValue = 7
        write(expectedValue, into: containerTested)
        @Observe(containerTested, storage: storage) var result;
        XCTAssertEqual(result, expectedValue)
    }

}
