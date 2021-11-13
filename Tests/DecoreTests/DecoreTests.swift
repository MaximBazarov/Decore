import XCTest
@testable import Decore

final class DecoreTests: XCTestCase {


    struct TestContainer: Container {
        static func value() -> Int { 1 }
    }

    func test_Observe_should_work() {
        @Observe(TestContainer.self) var sut;
        XCTAssertEqual(sut, 1)
    }
}
