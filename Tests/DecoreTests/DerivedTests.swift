import XCTest
import Decore
import DecoreStorage

final class DerivedTests: XCTestCase {

    // MARK: - Test state definition

    struct A: Atom, Mutable {
        static var initial = { 7 }
    }

    struct B: Atom {
        static var initial = { 13 }
    }

    struct SumAB: Derived, Mutable {
        static func setValue(_ value: Int, write: Writer) {
            let a = value / 2
            let b = value - a
            write(a, for: A.self)
            write(b, for: B.self)
        }

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
        @StateOf(SumAB.self) var sumAB;
        @BindingTo(A.self) var A; // 7
        @StateOf(B.self) var B; // 13

        XCTAssertEqual(sumAB, A + B)

        A = 5
        XCTAssertEqual(sumAB, A + B)
    }

    func test_BindingTo_Derived_setValue_ShouldChangeOriginalsAsDefinedinDerived() {
        @StateOf(A.self) var A;
        @StateOf(B.self) var B;
        @BindingTo(SumAB.self) var value;

        XCTAssertEqual(value, A + B)
        value = 10
        XCTAssertEqual(A, 5)
        XCTAssertEqual(B, 5)
    }

}

