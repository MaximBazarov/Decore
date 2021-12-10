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

    public func onUpdate(read: Storage.Reader, write: Storage.Writer) {

    }


    // MARK: - Subscription -

//    var cancelations
//    private func subscribeToPublishers(of obj: Any) {
//        cancelations.forEach{ $0.cancel() }
//        let mirror = Mirror(reflecting: obj)
//        guard mirror.children.count > 0 else { return }
//        for child in mirror.children {
//            subscribeToPublishers(of: child)
//        }
//    }
//
//    @available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
//    private func subscribeToPublishers(of child: Mirror.Child) {
//        if let matchingChild = child.value as? ObservableObjectPublisher {
//            let cancelation = matchingChild.sink { [weak self] _ in
//                self?.valueUpdated()
//            }
//            cancelations.append(cancelation)
//            return
//        }
//        let mirror = Mirror(reflecting: child.value)
//        guard mirror.children.count > 0 else { return }
//        for grandChild in mirror.children {
//            subscribeToPublishers(of: grandChild)
//        }
//    }

}

#endif
