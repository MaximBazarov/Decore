//
//  GroupState_RWTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class GroupState_RWTests: XCTestCase {

    struct G: GroupState {
        typealias Element = Int
        typealias ID = Int
        static func initialValue(for id: Int) -> Int { 0 }
    }

    let containerTested = G.self
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
        let id = 1
        let expectedValue = containerTested.initialValue(for: id)
        let result = read(containerTested, at: id)
        XCTAssertEqual(result, expectedValue)
    }

    func test_Reader_callAsFunction_Atom_PresetValue_shouldReturnWrittenValue() throws {
        let id = 2
        let expectedValue = 7
        write(expectedValue, into: containerTested, at: id)
        let result = read(containerTested, at: id)
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - Writer -

    func test_Writer_callAsFunction_Atom_shouldReturnWrittenValue() throws {
        let id = 3
        let expectedValue = 8
        write(expectedValue, into: containerTested, at: id)
        let result = read(containerTested, at: id)
        XCTAssertEqual(result, expectedValue)
    }


}
