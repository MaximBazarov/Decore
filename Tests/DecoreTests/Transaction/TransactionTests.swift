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
        let transaction = Transaction(Storage(), context: .here())
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
        let transaction = Transaction(storage, context: .here())
        _ = transaction.readValue(
            at: container,
            readerKey: depender1,
            fallbackValue: { 1 })
        _ = transaction.readValue(
            at: container,
            readerKey: depender2,
            fallbackValue: { 2 })

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
        let container = Storage.Key.container(String(describing: self))
        let expected = { 890 }
        let transaction = Transaction(Storage(), context: .here())
        let result = transaction.readValue(
            at: container, readerKey: nil,
            fallbackValue: expected
        )
        XCTAssertEqual(expected(), result)
    }

    func test_Transaction_read_StorageHasValue_Read_returnsStorageValue() throws {
        let container = Storage.Key.container(String(describing: self))
        let storage = Storage()
        let transaction = Transaction(storage, context: .here())

        let fallbackValue = { -900 }
        let storageValue = 9001

        storage.values[container] = storageValue

        let result = transaction.readValue(
            at: container,
            readerKey: nil,
            fallbackValue: fallbackValue)

        XCTAssertEqual(result, storageValue)
    }

    func test_Transaction_read_BothStorageAndTransactionHaveValues_Read_returnsTransactionValue() throws {
        let container = Storage.Key.container(String(describing: self))
        let storage = Storage()
        let transaction = Transaction(storage, context: .here())

        let transactionValue = 9087
        let fallbackValue = { -900 }
        let storageValue = -800

        storage.values[container] = storageValue
        transaction.values[container] = transactionValue

        let result = transaction.readValue(
            at: container,
            readerKey: nil,
            fallbackValue: fallbackValue)

        XCTAssertEqual(result, transactionValue)
    }

    // MARK: - Write -

    func test_Transaction_readValue_NoValuesStorage_writesInitialValues_writtenValuesShouldBeInUpdatedValues() throws {
        let storage = Storage()
        let transaction = Transaction(storage, context: .here())
        let expected = 0
        let target = Storage.Key.container(String(describing: self))
        _ = transaction.readValue(at: target, readerKey: nil, fallbackValue: { expected })
        // we need to write initital value into transaction before return
        XCTAssertEqual(transaction.values[target] as? Int, expected)
    }

}
