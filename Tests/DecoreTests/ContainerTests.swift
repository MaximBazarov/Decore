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
        storage.write(7, into: TestContainer.self)
        let read = Storage.Reader(storage: storage)
        let result = read(TestContainer.self)
        XCTAssertEqual(result, 7)
    }

    func test_Reader_callAsFunction_shouldAddDependency() throws {
        let storage = Storage()
        let destination = TestContainer.key()
        storage.update(value: 7, atKey: destination)
        let owner = Storage.Key.container("test")
        let read = Storage.Reader(storage: storage, owner: owner)
        let _ = read(TestContainer.self)
        let dependencies = storage
            .dependencies[destination] ?? []

        XCTAssertNotNil(dependencies.count == 1)
        let dependency = try XCTUnwrap(dependencies.first)
        XCTAssertTrue(dependency == owner)
    }

    func test_Observe_writeNewValue_shouldPublishValueChange() throws {

        @Observe(TestContainer.self) var testValue

        let storage = Storage()
        let destination = TestContainer.key()

        storage.update(value: 7, atKey: destination)
        XCTAssertEqual(testValue, 7)

    }
}
