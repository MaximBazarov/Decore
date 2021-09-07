/// The entity conforming to this protocol has the ``Storage`` injected as `storage`
public protocol StorageInjected {

    /// Injected storage
    var storage: Storage { get }
}

public
extension StorageInjected {

    /// Injected storage default value is
    /// ``StorageManager`` storage.
    var storage: Storage { StorageManager.storage }
}

/// Storage Manager holds is a point of implicit injection
/// of the ``Storage`` set `.storage` to change the
/// default storage for the whole app
/// Use this manager only if SwiftUI is not available to you,
/// for SwiftUI application use DecoreUI framework to utilise Environment
public
class StorageManager {

    private static var shared = StorageManager()

    private var value: Storage = Storage()

    /// Shared storage across all
    /// the consumers.
    public
    static var storage: Storage {
        get { StorageManager.shared.value }
        set { StorageManager.shared.value = newValue }
    }
}

