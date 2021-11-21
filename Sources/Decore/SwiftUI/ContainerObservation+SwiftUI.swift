
#if canImport(Combine) && canImport(SwiftUI)
import SwiftUI
import Combine

/// Accesses the container in read/write mode,
/// observing changes and notifying through `ObservableObject.ObjectWillChangePublisher`
@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public class ContainerObservation: Storage.Observation, ObservableObject {

    /// This property is required for SwiftUI View
    /// to get notified about data changes.
    public let objectWillChange = ObservableObjectPublisher()

    // MARK: - Observation

    /// Storage ``Observation`` callback
    override func willChangeValue() {
        objectWillChange.send()
        super.willChangeValue()
    }
    
}

#endif
