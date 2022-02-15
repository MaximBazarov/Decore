//
//  ContainerObservation+SwiftUI.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

import SwiftUI
import Combine

/// Accesses the container in read/write mode,
/// observing changes and notifying through `ObservableObject.ObjectWillChangePublisher`
class ObservableStorageObject: StorageObservation, ObservableObject {
    let objectWillChange = ObservableObjectPublisher()

    public func willChangeValue() {
        objectWillChange.send()
    }
}
