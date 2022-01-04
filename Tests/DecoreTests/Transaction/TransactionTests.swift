//
//  StorageObservationTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
@testable import Decore


class TransactionTests: XCTestCase {

    // MARK: - Dependencies -

    func test_Transaction_addDependencies_shouldContainAddedDependencies() throws {
        let transaction = Transaction(Storage())
        let target = Storage.Key.container("target")
        let depender1 = Storage.Key.container("depender1")
        let depender2 = Storage.Key.container("depender2")
        transaction.insertDependency(depender1, for: target)
        transaction.insertDependency(depender2, for: target)
        XCTAssertTrue(
            transaction
                .dependenciesOf[target, default: []]
                .contains(depender1)
        )
        XCTAssertTrue(
            transaction
                .dependenciesOf[target, default: []]
                .contains(depender2)
        )
    }

    func test_Transaction_read_shouldAddDependencies() throws {
        let container = Storage.Key.container(String(describing: self))
        let depender1 = Storage.Key.container("depender1")
        let depender2 = Storage.Key.container("depender2")
        let storage = Storage()
        let transaction = Transaction(storage)
        _ = transaction.readValue(
            at: container,
            fallbackValue: { 0 },
            depender: depender1)
        _ = transaction.readValue(
            at: container,
            fallbackValue: { 0 },
            depender: depender2)
        XCTAssertTrue(
            transaction
                .dependenciesOf[container, default: []]
                .contains(depender1)
        )
        XCTAssertTrue(
            transaction
                .dependenciesOf[container, default: []]
                .contains(depender2)
        )
    }

    // MARK: - Read -

    func test_Transaction_read_Empty_Read_returnsFallbackValue() throws {
        let expected = { 890 }
        let transaction = Transaction(Storage())
        let result = transaction.readValue(
            at: .container("test"),
            fallbackValue: expected)
        XCTAssertEqual(expected(), result)
    }

    func test_Transaction_read_StorageHasValue_Read_returnsStorageValue() throws {
        let container = Storage.Key.container(String(describing: self))
        let storage = Storage()
        let transaction = Transaction(storage)

        let fallbackValue = { -900 }
        let storageValue = 9001

        storage.values[container] = storageValue

        let result = transaction.readValue(
            at: container,
            fallbackValue: fallbackValue)

        XCTAssertEqual(result, storageValue)
    }

    func test_Transaction_read_BothStorageAndTransactionHaveValues_Read_returnsTransactionValue() throws {
        let container = Storage.Key.container(String(describing: self))
        let storage = Storage()
        let transaction = Transaction(storage)

        let transactionValue = 9087
        let fallbackValue = { -900 }
        let storageValue = -800

        storage.values[container] = storageValue
        transaction.values[container] = transactionValue

        let result = transaction.readValue(
            at: container,
            fallbackValue: fallbackValue)

        XCTAssertEqual(result, transactionValue)
    }

    // MARK: - Write -

}
