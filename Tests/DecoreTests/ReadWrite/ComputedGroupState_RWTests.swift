//
//  GroupState_RWTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class ComputedGroupState_RWTests: XCTestCase {


    struct A: AtomicState {
        typealias Value = Int
        static var initialValue: () -> Int = { 10 }
    }

    struct G: ComputedGroupState {
        typealias Element = Int
        typealias ID = Int
        static func value(at id: Int, read: Storage.Reader) -> Int {
            return id * read(A.self)
        }
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
        let expectedValue = id * A.initialValue()
        let result = read(containerTested, at: id)
        XCTAssertEqual(result, expectedValue)
    }

    func test_Reader_callAsFunction_Atom_PresetValue_shouldReturnWrittenValue() throws {
        let id = 2
        let newA = 20
        let expectedValue = id * newA
        write(newA, into: A.self)
        let result = read(containerTested, at: id)
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - Writer -

    func test_Writer_callAsFunction_Atom_shouldReturnWrittenValue() throws {
        let id = 3
        let newA = 30
        let expectedValue = id * newA
        write(newA, into: A.self)
        let result = read(containerTested, at: id)
        XCTAssertEqual(result, expectedValue)
    }


}
