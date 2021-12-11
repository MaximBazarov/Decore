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
class Consumer {

    public func onUpdate() {}

    public init() {
        subscribeToPublishers(of: self)
    }

    // MARK: - Subscription -

    private let context = Context.here()

    private var cancelations: [AnyCancellable] = []

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
        if let matchingChild = child.value as? ObservableObjectPublisher {
            let id = ObjectIdentifier(matchingChild)
            if subscribed.contains(id) { return }
            subscribed.insert(id)
            let cancelation = matchingChild.sink { [weak self] _ in
                self?.valueUpdated()
            }
            cancelations.append(cancelation)
            return
        }
        let mirror = Mirror(reflecting: child.value)
        guard mirror.children.count > 0 else { return }
        for grandChild in mirror.children {
            subscribeToPublishers(of: grandChild)
        }
    }

    deinit {
        cancelations.forEach { $0.cancel() }
    }

}

#endif
