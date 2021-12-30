//  
//  WritableComputedState_ObserveTests.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//


import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class WritableComputedState_ObserveTests: XCTestCase {

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
    var storage: Storage!

    override func setUp() {
        storage = Storage()
        write = Storage.Writer(context: .here(), storage: storage, owner: Sum.key())
    }


    // MARK: - Read -

    func test_Observe_WritableComputedState_InitialValues_shouldReturnInitialValuesSum() throws {
        let expectedValue = A.initialValue() + B.initialValue()
        @Observe(containerTested, storage: storage) var result;
        XCTAssertEqual(result, expectedValue)
    }

    func test_Observe_WritableComputedState_WriteBValue_shouldReturnSumOfABValues() throws {
        let newB = 19
        let expectedValue = A.initialValue() + newB
        write(newB, into: B.self)
        @Observe(containerTested, storage: storage) var result;
        XCTAssertEqual(result, expectedValue)
    }

}
