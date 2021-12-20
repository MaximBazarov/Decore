//
//  ReaderTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
@testable import Decore

final class ReaderTests: XCTestCase {

    struct TestContainer: Container {
        typealias Value = Int
        static func initialValue() -> Value { 1 }
    }

    func test_Reader_callAsFunction_shouldReturnWrittenValue() throws {
        @StorageFor(Self.self) var storage
        let container = TestContainer.self
        let key = container.key()
        storage.update(value: 7, atKey: key)
        let read = Storage.Reader(context: Context(), storage: storage)
        let result = read(container)
        XCTAssertEqual(result, 7)
    }

}
