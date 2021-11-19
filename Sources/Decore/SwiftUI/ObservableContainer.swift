
#if canImport(Combine) && canImport(SwiftUI)
import SwiftUI
import Combine

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
final class ObservableContainer<Value>: Observation, ObservableObject {

    internal init(key: Storage.Key, fallbackValue: @escaping () -> Value) {
        self.key = key
        self.fallbackValue = fallbackValue
    }

    let key: Storage.Key
    let fallbackValue: () -> Value

    var value: Value {
        get {
            let storage = Warehouse[.defaultStorage]
            let read = Storage.Reader(storage: storage)
            storage.insertObservation(self, for: key)
            return read(key, fallbackValue: fallbackValue)
        }
        set {
            let storage = Warehouse[.defaultStorage]
            storage.update(value: newValue, atKey: key)
        }
    }

    let objectWillChange = ObservableObjectPublisher()

    override func willChangeValue() {
        objectWillChange.send()
        super.willChangeValue()
    }
}

#endif
