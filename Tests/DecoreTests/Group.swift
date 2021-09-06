import XCTest
import Decore
import DecoreStorage

final class GroupTests: XCTestCase {

    // MARK: - Test state definition

    struct G: Group, Mutable {
        static func initial(for id: Int) -> Int { id }
    }

    static let aID = 7
    static let bID = 13

    struct SumAB: Derived, Mutable {
        static func setValue(_ value: Int, write: Writer) {
            let a = value / 2
            let b = value - a
            write(a, for: G.self, at: aID)
            write(b, for: G.self, at: bID)
        }

        static var value: (Reader) -> Int = { read in
            read(G.self, at: aID) + read(G.self, at: bID)
        }
    }

    override func setUp() {
        // each test runs on a freshly created mint new storage.
        StorageManager.storage = Storage()
    }


    // MARK: - Tests

    func test_StateOf_Derived_writeValues_ShouldInvalidateAndDeriveActualValues() {
        @StateOf(SumAB.self) var sumAB;
        @BindingTo(G.self, at: Self.aID) var A;
        @StateOf(G.self, at: Self.bID) var B;

        XCTAssertEqual(sumAB, 20)
        A = 5
        XCTAssertEqual(sumAB, 18)
    }

    func test_BindingTo_Derived_setValue_ShouldChangeOriginalsAsDefinedinDerived() {
        @BindingTo(SumAB.self) var sumAB;
        @BindingTo(G.self, at: Self.aID) var A;
        @StateOf(G.self, at: Self.bID) var B;

        XCTAssertEqual(sumAB, A + B)
        sumAB = 10
        XCTAssertEqual(A, 5)
        XCTAssertEqual(B, 5)
    }

}

