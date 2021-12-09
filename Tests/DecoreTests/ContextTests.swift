import XCTest
@testable import Decore

final class ContextTests: XCTestCase {

    struct ContainerA: Container {
        typealias Value = String
        static func initialValue() -> String { "" }
    }

    @Observe(ContainerA.self) var a

    func test_Context() throws {
        print(_a.context)
    }

}
