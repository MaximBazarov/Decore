import XCTest
@testable import Decore

final class ContainerTests: XCTestCase {


    struct TestContainer: Container {
        typealias Value = Int
        static func initialValue() -> Value { 1 }
    }

    func test_writeContainerValue_valueShouldBeWrittenIntoStorage() throws {
        let storage = Storage()
        storage.write(7, into: TestContainer.self)

        let result = try XCTUnwrap(
            storage.storage[TestContainer.key()] as? Int
        )
        XCTAssertEqual(result, 7)
    }

    func test_Reader_callAsFunction_shouldReturnWrittenValue() throws {
        let storage = Storage()
        let container = TestContainer.self
        storage.write(7, into: container)
        let read = Storage.Reader(storage: storage)
        let result = read(container)
        XCTAssertEqual(result, 7)
    }

}
