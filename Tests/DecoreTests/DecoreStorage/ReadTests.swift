import XCTest
@testable import Decore

final class AtomeTests: XCTestCase {

    // MARK: - Test state definition

    struct A: Atom, Mutable {
        static var initial = { 7 }
    }

    // MARK: - Tests

    func test_Storage_Write_ValueShouldBeEqualWrittenOne() {
        let storage = Storage()
        storage.write(
            7,
            into: A.key,
            context: .inline(self)
        )
        XCTAssertEqual(storage.values[A.key] as? Int ?? 0, 7)
    }

    func test_Storage_Read_ValueShouldBeEqualWrittenOne() {
        let storage = Storage()
        storage.values[A.key] = 7
        let value = storage.read(
            A.key,
            context: .inline(self),
            fallbackValue: { 0 }
        )
        XCTAssertEqual(value, 7)
    }


}
