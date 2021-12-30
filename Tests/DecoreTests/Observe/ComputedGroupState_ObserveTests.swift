//  
//  ComputedGroupState_ObserveTests.swift
//  Decore
//
//  Created by Maxim Bazarov 
//  Copyright © 2021 Maxim Bazarov
//


import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class ComputedGroupState_ObserveTests: XCTestCase {

    struct A: AtomicState {
        typealias Value = Int
        static var initialValue: () -> Value = { 1 }
    }

    struct B: AtomicState {
        typealias Value = Int
        static var initialValue: () -> Value = { 2 }
    }

    struct G: ComputedGroupState {
        typealias Element = Int
        typealias ID = Int

        static func value(at id: ID, read: Storage.Reader) -> Int {
            return read(A.self) + read(B.self) * id
        }
    }

    let containerTested = G.self
    var write: Storage.Writer!
    var storage: Storage!

    override func setUp() {
        storage = Storage()
        write = Storage.Writer(context: .here(), storage: storage, owner: G.key())
    }


    // MARK: - Read -

    func test_Observe_ComputedGroupState_InitialValues_shouldReturnInitialValuesSum() throws {
        let id = 2
        let expectedValue = A.initialValue() + B.initialValue() * id
        @Observe(containerTested, storage: storage) var result;
        XCTAssertEqual(result[id], expectedValue)
    }

    func test_Observe_ComputedGroupState_WrittenBValue_shouldReturnSumOfABValues() throws {
        let id = 3
        let newB = 9
        let expectedValue = A.initialValue() + newB * id
        write(newB, into: B.self)
        @Observe(containerTested, storage: storage) var result;
        XCTAssertEqual(result[id], expectedValue)
    }

}
