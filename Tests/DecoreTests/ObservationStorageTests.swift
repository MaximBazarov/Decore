import XCTest
@testable import Decore

final class ObservationStorageTests: XCTestCase {

    func test_writeContainerValue_valueShouldBeWrittenIntoStorage() throws {
        let storage = Storage()
        let obs1 = Storage.Observation()
        let obs2 = Storage.Observation()
        let key = Storage.Key.container("test")

        storage.insertObservation(obs1, for: key)
        storage.insertObservation(obs2, for: key)

        guard let observationStorage = storage.observations[key] else {
            XCTFail("Must be 2 observations, found 0")
            return
        }

        XCTAssertEqual(observationStorage.observationStorage.count, 2)
    }

}
