//
//  WritableComputedState_RWTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class WritableComputedState_RWTests: XCTestCase {

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
    var read: Storage.Reader!
    var write: Storage.Writer!
    var storage: Storage!

    override func setUp() {
        storage = Storage()
        read = Storage.Reader(context: .here(), storage: storage, owner: Sum.key())
        write = Storage.Writer(context: .here(), storage: storage, owner: Sum.key())
    }

    // MARK: - Calculation -

    func test_Reader_WritableComputedState_value_initialValuesAB_shouldReturnAPlusB() throws {
        let expectedValue = A.initialValue() + B.initialValue()
        let result = read(containerTested)
        XCTAssertEqual(result, expectedValue)
    }

    func test_Reader_WritableComputedState_value_writeValuesAB_shouldReturnAPlusB() throws {
        let a = 9
        let b = 10
        let expectedValue = a + b
        write(a, into: A.self)
        write(b, into: B.self)
        let result = read(containerTested)
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - Recalculation -

    func test_Reader_WritableComputedState_value_readInitial_setNewB_shouldReturnAPlusUpdatedB() throws {
        var result = read(containerTested)
        XCTAssertEqual(result, A.initialValue() + B.initialValue())
        let newB = 10
        write(newB, into: B.self)
        result = read(containerTested)
        XCTAssertEqual(result, A.initialValue() + newB)
    }


    // MARK: - Writing -

    func test_Writer_WritableComputedState_callAsFunction_Atom_shouldReturnWrittenValue() throws {
        let newA = 12
        let expectedValue = newA + B.initialValue()
        write(expectedValue, into: containerTested)
        XCTAssertEqual(read(containerTested), expectedValue)
        XCTAssertEqual(read(A.self), newA)
        XCTAssertEqual(read(B.self), expectedValue - newA)
    }

}
