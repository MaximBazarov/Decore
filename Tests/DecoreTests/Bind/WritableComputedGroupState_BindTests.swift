//
//  WritableComputedGroupState_BindTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class WritableComputedGroupState_BindTests: XCTestCase {

    struct A: GroupState {
        typealias Element = Int
        typealias ID = Int

        static func initialValue(for id: ID) -> Element {
            1
        }
    }

    struct B: GroupState {
        typealias Element = Int
        typealias ID = Int

        static func initialValue(for id: ID) -> Element {
            2
        }
    }

    struct Sum: WritableComputedGroupState {
        typealias Element = Int
        typealias ID = Int

        static func value(at id: Int, read: Storage.Reader) -> Int {
            return read(A.self, at: id) + read(B.self, at: id)
        }

        static func setValue(_ value: Int, at id: Int, read: Storage.Reader, write: Storage.Writer) {
            let a = read(A.self, at: id)
            write(value - a, into: B.self, at: id)
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
        let id = 333
        let expectedValue = A.initialValue(for: id) + B.initialValue(for: id)
        @Bind(containerTested, storage: storage) var result;
        XCTAssertEqual(result[id], expectedValue)
    }

    func test_Bind_WritableComputedState_WriteValue_shouldReturnWrittenValue() throws {
        let id = 334
        let newB = 34
        let expectedValue = A.initialValue(for: id) + newB
        @Bind(containerTested, storage: storage) var result;
        write(expectedValue, into: containerTested, at: id)
        XCTAssertEqual(result[id], expectedValue)
        XCTAssertEqual(read(A.self, at: id), A.initialValue(for: id))
        XCTAssertEqual(read(B.self, at: id), newB)
    }
}
