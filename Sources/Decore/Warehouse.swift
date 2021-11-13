import Foundation
/// Warehouse id a static storage of ``Storage``.
/// Access:
/// ```swift
/// let storage = Warehouse[.defaultStorage]
/// // returns the default storage
/// ```
///
/// **To Be Implemented:**
/// ```swift
/// let sceneStorage = Warehouse[.storage(uniqueStorageID)]
/// ```
///
final class Warehouse {

    /// Storage unique identifier.
    public enum Key: Hashable {
        case defaultStorage

        // Point of improvement: Unique identifier to use in persistence layer
        // e.g. file name, data base table name etc.
        // TODO: case storage(UniqueIDPersistentAcrossSessions)
    }

    public static subscript(_ key: Key) -> Storage {
        guard let storageForKey = warehouse[key] else {
            let newStorage = Storage()
            warehouse[key] = newStorage
            return newStorage
        }
        return storageForKey
    }


    private static var warehouse: [Key: Storage] = [
        .defaultStorage: Storage()
    ]
}


