//
//  AtomicStateRWTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class AtomicStateRWTests: XCTestCase {

    // MARK: - AtomicState -

    struct A: AtomicState {
        typealias Value = Int
        static var initialValue: () -> Value = { 0 }
    }

    let containerTested = A.self
    var read: Storage.Reader!
    var write: Storage.Writer!
    var storage: Storage!

    override func setUp() {
        storage = Storage()
        read = Storage.Reader(context: .here(), storage: storage)
        write = Storage.Writer(context: .here(), storage: storage)
    }

    // MARK: - Reader -

    func test_Reader_callAsFunction_Atom_shouldReturnInitialValue() throws {
        let expectedValue = A.initialValue()
        let result = read(containerTested)
        XCTAssertEqual(result, expectedValue)
    }

    func test_Reader_callAsFunction_Atom_PresetValue_shouldReturnWrittenValue() throws {
        let expectedValue = 7
        write(expectedValue, into: containerTested)
        let result = read(containerTested)
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - Writer -

    func test_Writer_callAsFunction_Atom_shouldReturnWrittenValue() throws {
        let expectedValue = 8
        write(expectedValue, into: containerTested)
        let result = read(containerTested)
        XCTAssertEqual(result, expectedValue)
    }


}
