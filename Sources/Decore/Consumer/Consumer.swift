//
//  Consumer.swift
//  Decore
//
//  Created by Maxim Bazarov
//  Copyright © 2020 Maxim Bazarov
//

#if canImport(Combine) && canImport(SwiftUI)
import SwiftUI
import Combine

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public class Consumer {

    public func onUpdate() {}

    public init() {
        subscribeToPublishers(of: self)
    }

    // MARK: - Subscription -

    private let context = Context.here()

    private var cancelations: Set<AnyCancellable> = []

    private func valueUpdated() {
        onUpdate()
    }

    var subscribed: Set<ObjectIdentifier> = []
    func subscribeToPublishers(of obj: Any) {
        cancelations.forEach{ $0.cancel() }
        subscribed = []
        let mirror = Mirror(reflecting: obj)
        guard mirror.children.count > 0 else { return }
        for child in mirror.children {
            subscribeToPublishers(of: child)
        }
    }

    private func subscribeToPublishers(of child: Mirror.Child) {
        let className = String(describing: child.value)
        print("* Child \(className)")

        // ContainerObservation found
        if className.contains("Decore.ObservableStorageObject"),
           let observation = child.value as? Decore.ObservableStorageObject
        {
            print(" ++ Subscribed for \(observation.id)")
            let cancelation = observation.objectWillChange.sink { [weak self] _ in
                print(" -> Value updated for \(className)")
                self?.valueUpdated()
            }
            cancelations.insert(cancelation)
            return
        }

        if className.contains("ObservedObject<ObservableStorageObject>") {
            let mirror = Mirror(reflecting: child.value)
            guard mirror.children.count > 0 else { return }
            for grandChild in mirror.children {
                subscribeToPublishers(of: grandChild)
            }
            return
        }

        if className.contains("Observe<")
            || className.contains("Bind<")
        {
            let mirror = Mirror(reflecting: child.value)
            guard mirror.children.count > 0 else { return }
            for grandChild in mirror.children {
                subscribeToPublishers(of: grandChild)
            }
            return
        }
        else {
            print(" -> Skipping child  \(className)")
        }
    }

    deinit {
        cancelations.forEach { $0.cancel() }
    }

}

#endif
