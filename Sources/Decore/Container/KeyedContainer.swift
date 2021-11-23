public protocol KeyedContainer {

    /// Must return a unique key to store the value in the storage.
    /// - Returns: ``Storage/Key``
    static func key() -> Storage.Key
}

