//
//  ObserveTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
@testable import Decore

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class AtomTests: XCTestCase {

    // MARK: - Atom -

    struct A: Atom {
        typealias Value = Int
        static var initialValue: () -> Value = { 0 }
    }

    // MARK: - Reader -

    func test_Reader_callAsFunction_Atom_shouldReturnInitialValue() throws {
        let storage = Storage()
        let container = A.self
        // Since value hasn't been written must return an initial value
        let expectedValue = A.initialValue()
        let read = Storage.Reader(context: Context(), storage: storage)
        let result = read(container)
        XCTAssertEqual(result, expectedValue)
    }

    func test_Reader_callAsFunction_Atom_PresetValue_shouldReturnWrittenValue() throws {
        let storage = Storage()
        let container = A.self
        let key = container.key()
        let expectedValue = 7
        storage.update(value: expectedValue, atKey: key)
        let read = Storage.Reader(context: Context(), storage: storage)
        let result = read(container)
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - Writer -

    func test_Writer_callAsFunction_Atom_shouldReturnWrittenValue() throws {
        let storage = Storage()
        let container = A.self
        let key = container.key()
        let expectedValue = 7

        let write = Storage.Writer(context: Context(), storage: storage)
        write(expectedValue, into: key)
        let result = storage.readValue(
            at: key,
            fallbackValue: A.initialValue,
            context: .here()
        )
        XCTAssertEqual(result, expectedValue)
    }

    // MARK: - Observe -

    func test_Observe_Atom_PresetValue_shouldReadPresetValue() throws {
        @StorageFor(Self.self) var storage
        @Observe(A.self) var a
        let container = A.self
        let key = container.key()
        let expectedValue = 7
        storage.update(value: expectedValue, atKey: key)
        XCTAssertEqual(a, expectedValue)
    }

    // MARK: - Bind -

    func test_Bind_Atom_PresetValue_shouldReadPresetValue() throws {
        @StorageFor(Self.self) var storage
        @Bind(A.self) var a
        let container = A.self
        let key = container.key()
        let expectedValue = 7
        storage.update(value: expectedValue, atKey: key)
        XCTAssertEqual(a, expectedValue)
    }

    func test_Bind_Atom_SetValue_storageReadsSetValueValue() throws {
        @StorageFor(Self.self) var storage
        @Bind(A.self) var a
        let container = A.self
        let key = container.key()
        let expectedValue = 7
        a = expectedValue
        let result = storage.readValue(
            at: key,
            fallbackValue: A.initialValue,
            context: .here()
        )
        XCTAssertEqual(result, expectedValue)
        XCTAssertEqual(a, expectedValue)
    }

}
