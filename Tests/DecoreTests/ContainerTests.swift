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

}
