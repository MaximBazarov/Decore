//
//  ConsumerTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

//
//@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
//final class ConsumerTests: XCTestCase {
//
//    final class TestClass: Consumer {
//
//        @Observe(IntTested.self) var testContainerA
//        @Bind(StringTested.self) var testContainerB
//        @Bind(ArrayTested.self) var testArray
//
//        var updatesCount: Int = 0
//
//        override func onUpdate() {
//            updatesCount += 1
//        }
//
//    }
//
//    struct ArrayTested: AtomicState {
//        typealias Value = [Int]
//        static var initialValue: () -> [Int] = { [] }
//    }
//
//    struct IntTested: AtomicState {
//        typealias Value = Int
//        static var initialValue = { 1 }
//    }
//
//    struct StringTested: AtomicState {
//        typealias Value = Int
//        static var initialValue = { 1 }
//    }
//
//    // MARK: - Observe -
//
//    func test_Observe_TwoContainersChange_shouldReceiveTwoUpdates() throws {
//        @StorageFor(Self.self) var storage
//        let a = TestContainerA.self
//        let b = TestContainerA.self
//        let sut = TestClass()
//        sut.run()
//        storage.write(value: 7, atKey: a.key())
//        storage.write(value: 8, atKey: b.key())
//        XCTAssertGreaterThan(sut.updatesCount, 0)
//    }
//
//
//    final class ArrayContainerConsumer: Consumer {
//
//        @Bind(TestArrayContainer.self) var array
//
//        var updatesCount: Int = 0
//        override func onUpdate() {
//            updatesCount += 1
//        }
//
//        func run() {
//            _ = array
//        }
//    }
//
//    func test_Observe_ArrayContainerAppend_shouldReceiveUpdate() throws {
//        let sut = ArrayContainerConsumer()
//        let sut2 = ArrayContainerConsumer()
//        sut.run()
//        sut2.run()
//        sut.array.append(1)
//        XCTAssertGreaterThan(sut.updatesCount, 0)
//        XCTAssertGreaterThan(sut2.updatesCount, 0)
//    }
//
//}
