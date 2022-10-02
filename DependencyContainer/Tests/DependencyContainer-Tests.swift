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

import XCTest
@testable import DependencyContainer

private protocol Interface: AnyObject {}
private final class InterfaceMock: Interface {}

@MainActor
final class DependencyContainer_Tests: XCTestCase {
    
    func test_Injected_then_returnsDefaultInstance() throws {
        let defaultInstance = InterfaceMock()
        @Injected(as: Interface.self) var sut = { defaultInstance }
        
        XCTAssertEqual(ObjectIdentifier(defaultInstance), ObjectIdentifier(sut))
    }
    
    func test_Injected_Global_when_injectGlobal_then_returnsInjectedInstance() throws {
        let defaultInstance = InterfaceMock()
        let injectedInstance = InterfaceMock()
        @Injected(as: Interface.self) var sut = { defaultInstance }
        
        DependencyContainer.default.injectGlobal(injectedInstance, of: Interface.self)
        
        XCTAssertEqual(ObjectIdentifier(injectedInstance), ObjectIdentifier(sut))
    }
    
    func test_Injected_Global_when_injectForConsumer_then_returnsDefault() throws {
        let defaultInstance = InterfaceMock()
        let injectedInstance = InterfaceMock()
        @Injected(as: Interface.self) var sut = { defaultInstance }
        
        DependencyContainer.default
            .inject(injectedInstance, of: Interface.self, for: Self.self)
        
        XCTAssertEqual(ObjectIdentifier(defaultInstance), ObjectIdentifier(sut))
    }
    
    func test_Injected_ForConsumer_when_injectForConsumer_then_returnsInjected() throws {
        let defaultInstance = InterfaceMock()
        let injectedInstance = InterfaceMock()
        @Injected(as: Interface.self, into: Self.self) var sut = { defaultInstance }
        
        DependencyContainer.default
            .inject(injectedInstance, of: Interface.self, for: Self.self)
        
        XCTAssertEqual(ObjectIdentifier(injectedInstance), ObjectIdentifier(sut))
    }
}
