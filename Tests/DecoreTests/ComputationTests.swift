import XCTest
import Decore

final class ComputationTests: XCTestCase {

    // MARK: - Test state definition

    struct A: Atom, Mutable {
        static var initial = { 7 }
    }

    struct B: Atom {
        static var initial = { 13 }
    }

    struct SumAB: Computation, Mutable {

        static var value: (Reader) -> Int = { read in
            read(A.self) + read(B.self)
        }

    }

    override func setUp() {
        // each test runs on a freshly created mint new storage.
        StorageManager.storage = Storage()
    }

    // MARK: - Tests
    
    func test_StateOf_Derived_writeValues_ShouldInvalidateAndDeriveActualValues() {
        @StateOf(SumAB.self) var sumAB
        @BindingTo(A.self) var A
        @StateOf(B.self) var B;

        XCTAssertEqual(sumAB, (A + B))
        A = 5
        XCTAssertEqual(sumAB, A + B)
    }

}

