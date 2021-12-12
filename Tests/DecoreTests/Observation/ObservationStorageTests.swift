//
//  ObservationStorageTests.swift
//  Decore
//
//  Copyright © 2020 Maxim Bazarov
//

import XCTest
@testable import Decore

final class ObservationStorageTests: XCTestCase {


    class Observation: StorageObservation {
        func willChangeValue() {}
    }

    func test_ObservationStorage_addTwoObservationsForTheKey_shouldStoreBothObservations() throws {
        let storage = Storage()
        let obs1 = Observation()
        let obs2 = Observation()
        let key = Storage.Key.container("test")

        storage.insertObservation(obs1, for: key, context: Context())
        storage.insertObservation(obs2, for: key, context: Context())

        guard let observationStorage = storage.observations[key] else {
            XCTFail("Must be 2 observations, found 0")
            return
        }

        XCTAssertEqual(observationStorage.observationStorage.count, 2)
    }

}
