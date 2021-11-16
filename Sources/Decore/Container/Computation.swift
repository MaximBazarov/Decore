/// Computation is the ``Container`` that calculates a value
/// depending on the other values in the storage that ``Computation`` reads during computation.
/// if ``Computation/shouldStoreComputedValue()-2c6d5`` returns true,
/// the computed value will be written into the ``Storage``.
/// By default it returns `true`.
///
/// **Usage:**
/// TBD
public protocol Computation: KeyedContainer {

    /// Called to decide whether to write the value into the ``Storage`` or not.
    /// Return true to write value into the ``Storage``
    static func shouldStoreComputedValue() -> Bool

    /// Called when when computation value is read
    /// and there is no valid value in the ``Storage``.
    ///
    /// `shouldStoreComputedValue()`: Defines whether a computed value
    /// should be written into the ``Storage``
    ///
    /// - Returns: ``Value``
    static func value(read: Storage.Reader) -> Value

    /// Must return a unique key to store the value in the storage.
    /// - Returns: ``Storage/Key``
    static func key() -> Storage.Key
}


// MARK: - Key Defaut Implementation

public extension Computation {
    /// Default implementation generates the ``Storage.Key`` from the type name
    /// of the conforming ``Container`` .
    static func key() -> Storage.Key {
        .container(String(describing: Self.self))
    }
}
extension Computation {
    static func shouldStoreComputedValue() -> Bool { true }
}


// MARK: - Storage Reader

public extension Storage.Reader {

//        let destination = container.key()
//        let selfKey =
//
//        var computedValue: C.Value {
//            let newValue = computation.value(read: self)
//            return newValue
//        }
//
//        if computation.shouldStoreComputedValue() {
//            guard let storedValue = self.read(key: destination) as? C.Value else {
//                let newValue = computedValue
//                update(container, value: newValue, atKey: container.key())
//                return newValue
//            }
//            return storedValue
//        } else {
//            return computedValue
//        }
//    }
}

