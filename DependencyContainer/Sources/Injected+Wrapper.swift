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
@propertyWrapper public struct Injected<Value> {
    
    typealias Key = DependencyContainer.Key
    
    public var wrappedValue: Value {
        return instance() ?? defaultInstance()
    }
    
    var instance: () -> Value?
    var defaultInstance: () -> Value
    
    public init<Consumer>(
        wrappedValue: @escaping () -> Value,
        as interface: Value.Type,
        into consumer: Consumer.Type,
        file: String = #file,
        fileID: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        let container = DependencyContainer.default
        defaultInstance = wrappedValue
        instance = {
            container.instance(of: interface, for: consumer)
        }
        container.inject(wrappedValue(), of: interface, for: consumer)
    }
    
    public init(
        wrappedValue: @escaping () -> Value,
        as interface: Value.Type,
        file: String = #file,
        fileID: String = #fileID,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        let container = DependencyContainer.default
        defaultInstance = wrappedValue
        instance = {
            container.instance(of: interface)
        }
        container.injectGlobal(wrappedValue(), of: interface)
    }

}
