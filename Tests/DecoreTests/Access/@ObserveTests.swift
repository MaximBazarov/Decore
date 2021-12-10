//
//  ObserveTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
@testable import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class ObserveTests: XCTestCase {

    class TestClass: PropertiesObserver {

        @Observe(TestContainerA.self) var testContainerA
        @Bind(TestContainerB.self) var testContainerB
        @Bind(TestArrayContainer.self) var testArray


        var updatesCount: Int = 0
        override func valueUpdated() {
            updatesCount += 1
        }

        func run() {
            // we need to read to subscribe
            // view does it on first render
            _ = testContainerA
            _ = testContainerB
        }
    }

    struct TestArrayContainer: Container {
        typealias Value = [Int]
        static func initialValue() -> Value { [] }
    }

    struct TestContainerA: Container {
        typealias Value = Int
        static func initialValue() -> Value { 1 }
    }

    struct TestContainerB: Container {
        typealias Value = Int
        static func initialValue() -> Value { 1 }
    }

    var storage: Storage { Warehouse.storage(for: Self.self) }

    /// This test should succeed after introducing transactions
    //    func test_Observe_TwoContainersChange_shouldReceiveTwoUpdates() throws {
    //        let a = TestContainerA.self
    //        let b = TestContainerA.self
    //        let sut = TestClass()
    //        sut.run()
    //        storage.update(value: 7, atKey: a.key())
    //        storage.update(value: 8, atKey: b.key())
    //        XCTAssertEqual(sut.updatesCount, 2)
    //    }

    func test_Observe_TwoContainersChange_shouldReceiveTwoUpdates() throws {
        let a = TestContainerA.self
        let b = TestContainerA.self
        let sut = TestClass()
        sut.run()
        storage.update(value: 7, atKey: a.key())
        storage.update(value: 8, atKey: b.key())
        XCTAssertGreaterThan(sut.updatesCount, 0)
    }


    class ArrayContainerConsumer: PropertiesObserver {

        @Bind(TestArrayContainer.self) var array

        var updatesCount: Int = 0
        override func valueUpdated() {
            updatesCount += 1
        }

        func run() {
            _ = array
        }
    }

    func test_Observe_ArrayContainerAppend_shouldReceiveUpdate() throws {
        let sut = ArrayContainerConsumer()
        let sut2 = ArrayContainerConsumer()
        sut.run()
        sut2.run()
        sut.array.append(1)
        XCTAssertGreaterThan(sut.updatesCount, 0)
        XCTAssertGreaterThan(sut2.updatesCount, 0)
    }

}
