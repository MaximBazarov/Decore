//
//  WritableComputedGroupState_RWTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class WritableComputedGroupState_RWTests: XCTestCase {

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
    var read: Storage.Reader!
    var write: Storage.Writer!
    var storage: Storage!

    override func setUp() {
        storage = Storage()
        read = Storage.Reader(context: .here(), storage: storage, owner: Sum.key())
        write = Storage.Writer(context: .here(), storage: storage, owner: Sum.key())
    }

    // MARK: - Calculation -

    func test_Reader_WritableComputedGroupState_value_initialValuesAB_shouldReturnAPlusB() throws {
        let id = 99
        let expectedValue = A.initialValue(for: id) + B.initialValue(for: id)
        let result = read(containerTested, at: id)
        XCTAssertEqual(result, expectedValue)
    }

    func test_Reader_WritableComputedGroupState_value_writeValuesAB_shouldReturnAPlusB() throws {
        let id = 101
        let a = 9
        let b = 22
        let expectedValue = a + b
        write(a, into: A.self, at: id)
        write(b, into: B.self, at: id)
        let result = read(containerTested, at: id)
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - Recalculation -

    func test_Reader_WritableComputedGroupState_value_readInitial_setNewB_shouldReturnAPlusUpdatedB() throws {
        let id = 111
        let newB = 11
        write(newB, into: B.self, at: id)
        let result = read(containerTested, at: id)
        XCTAssertEqual(result, A.initialValue(for: id) + newB)
    }


    // MARK: - Writing -

    func test_Writer_WritableComputedGroupState_callAsFunction_Atom_shouldReturnWrittenValue() throws {
        let id = 122
        let newB = 32
        let expectedValue = A.initialValue(for: id) + newB
        write(expectedValue, into: containerTested, at: id)
        XCTAssertEqual(read(containerTested, at: id), expectedValue)
        XCTAssertEqual(read(A.self, at: id), A.initialValue(for: id))
        XCTAssertEqual(read(B.self, at: id), newB)
    }

}
