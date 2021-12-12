//
//  ContainerObservation+SwiftUI.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

#if canImport(Combine) && canImport(SwiftUI)
import SwiftUI
import Combine

/// Accesses the container in read/write mode,
/// observing changes and notifying through `ObservableObject.ObjectWillChangePublisher`
@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
class ObservableStorageObject: StorageObservation, ObservableObject {
    let objectWillChange = ObservableObjectPublisher()

    public func willChangeValue() {
        objectWillChange.send()
    }
}

#endif
