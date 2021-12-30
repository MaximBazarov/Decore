//
//  WritableComputedState_BindTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class WritableComputedState_BindTests: XCTestCase {

    struct A: AtomicState {
        typealias Value = Int
        static var initialValue: () -> Value = { 1 }
    }

    struct B: AtomicState {
        typealias Value = Int
        static var initialValue: () -> Value = { 2 }
    }

    struct Sum: WritableComputedState {
        typealias Value = Int
        static func value(read: Storage.Reader) -> Int {
            return read(A.self) + read(B.self)
        }

        static func setValue(_ value: Int, read: Storage.Reader, write: Storage.Writer) {
            let a = read(A.self)
            write(value - a, into: B.self)
        }
    }

    let containerTested = Sum.self
    var write: Storage.Writer!
    var read: Storage.Reader!
    var storage: Storage!

    override func setUp() {
        storage = Storage()
        write = Storage.Writer(context: .here(), storage: storage)
        read = Storage.Reader(context: .here(), storage: storage)
    }

    // MARK: - Read -

    func test_Bind_WritableComputedState_read_InitialValue_shouldReturnInitialValue() throws {
        let expectedValue = A.initialValue() + B.initialValue()
        @Bind(containerTested, storage: storage) var result;
        XCTAssertEqual(result, expectedValue)
    }

    func test_Bind_WritableComputedState_WriteValue_shouldReturnWrittenValue() throws {
        let newB = 10
        let expectedValue = A.initialValue() + newB
        @Bind(containerTested, storage: storage) var result;
        write(expectedValue, into: containerTested)
        XCTAssertEqual(result, expectedValue)
        XCTAssertEqual(read(A.self), A.initialValue())
        XCTAssertEqual(read(B.self), newB)
    }
}
