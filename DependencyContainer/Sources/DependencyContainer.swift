//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Decore package open source project
//
// Copyright (c) 2020-2022 Maxim Bazarov and the Decore package
// open source project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
//



import Foundation

@MainActor
public final class DependencyContainer {
    private var storage = [Key: Any]()
    
    struct Key: Hashable {
        let interface: String
        let consumer: String
    }
    
    public static let `default` = DependencyContainer()
    
    func key<Interface, Consumer>(
        of interface: Interface.Type,
        for consumer: Consumer.Type = Any.self
    ) -> Key {
        return Key(
            interface: String(reflecting: interface),
            consumer: String(reflecting: consumer)
        )
    }

    func inject<Interface, Consumer, Instance>(
        _ instance: Instance,
        of interface: Interface.Type,
        for consumer: Consumer.Type
    ) {
        let key = key(of: interface, for: consumer)
        storage[key] = instance
    }
    
    func injectGlobal<Interface, Instance>(
        _ instance: Instance,
        of interface: Interface.Type
    ) {
        let key = key(of: interface)
        storage[key] = instance
    }
    
    func instance<Interface, Consumer, Instance>(
        of interface: Interface.Type,
        for consumer: Consumer.Type = Any.self
    ) -> Instance? {
        instance(
            for: key(of: interface, for: consumer)
        ) as? Instance
    }
    
    func instance(for key: Key) -> Any? {
        return storage[key]
    }
}


