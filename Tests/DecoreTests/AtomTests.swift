import XCTest
import Decore

final class AtomTests: XCTestCase {

    struct Item: Atom, Mutable {
        static var initial = { -1 }
    }

    override func setUp() {
        // each test runs on a freshly created mint new storage.
        StorageManager.storage = Storage()
    }

    func test_Storage_StateOf_Atom_writeValues_ShouldInvalidateAndReadActualValues() {
        let stream = [1,15,67,89,14]
        let expected = stream
        var result = [Int]()

        @StateOf(Item.self, onChange: { retain in
            result.append(retain())
        }) var item;

        @BindingTo(Item.self) var setValue;

        XCTAssertEqual(item, Item.initial())

        for value in stream {
            setValue = value
        }
        XCTAssertEqual(result, expected)
    }

    func test_Storage_BindingTo_Atom_writeValues_ShouldInvalidateAndReadActualValues() {
        let stream = [1,15,67,89,14]
        let expected = stream
        var result = [Int]()

        @StateOf(Item.self, onChange: { retain in
            result.append(retain())
        }) var item;

        @BindingTo(Item.self) var setValue;

        XCTAssertEqual(item, Item.initial())

        for value in stream {
            setValue = value
        }

        XCTAssertEqual(result, expected)
    }
}

