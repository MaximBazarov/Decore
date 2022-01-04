//
//  StorageObservationTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
@testable import Decore


class StorageTests: XCTestCase {

    // MARK: - Merge Transaction
    
    func test_Storage_merge_Transaction_shouldAddAllValues() throws {
        let storage = Storage()
        let transaction = Transaction(storage)
        let container = Storage.Key.container(String(describing: self))
        let expected = "089"
        transaction.values = [
            container: expected
        ]

        storage.mergeValues(of: transaction, into: storage)
        XCTAssertEqual(storage.values[container] as? String, expected)
    }

}
