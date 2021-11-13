import XCTest
@testable import Decore

final class ContainerGroupTests: XCTestCase {

    struct TestContainerGroup: ContainerGroup {

        typealias Value = Int
        static func value(for id: Int) -> Value { 1 }
    }

    func test_writeContainerGroupValue_valueShouldBeWrittenIntoStorage() throws {
        let storage = Storage()
        let id = 0
        storage.write(7, into: TestContainerGroup.self, at: id)
        let key = Storage.Key.group("TestContainerGroup", container: id)
        let result = try XCTUnwrap(
            storage.storage[key] as? Int
        )
        XCTAssertEqual(result, 7)
    }

}
